import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agri_ai/app/data/local/my_hive.dart';
import 'package:agri_ai/app/data/models/app_setting_model.dart';
import 'package:agri_ai/app/data/models/conversation_model.dart';
import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agri_ai/app/data/providers/conversation_provider.dart';
import 'package:agri_ai/app/data/providers/app_setting_provider.dart';

class ChatAiChatService {
  final ConversationProvider provider = Get.find();
  final AppSettingProvider appSettingProvider = Get.find();
  StreamSubscription<String>? _aiResponseSubscription;

  void initService() {
    // Initialize any service-specific setup here
  }

  Future<void> loadConversations(ChatAiChatState state) async {
    try {
      state.isLoadingConversations.value = true;
      state.isErrorGetConversations.value = false;
      final newConversations = await provider.getConversations(page: 1);

      // Create a Set of existing conversation IDs
      final existingConversationIds =
          state.listConversations.map((c) => c.id).toSet();

      // Filter out the new conversations that already exist in the list
      final uniqueConversations = newConversations
          .where((c) => !existingConversationIds.contains(c.id))
          .toList();

      // Add only unique conversations to the list
      state.listConversations.addAll(uniqueConversations);

      state.hasMoreConversations(newConversations.length == 10);
      state.updateDrawerList();
      state.isErrorGetConversations.value = false;
    } catch (e) {
      state.isErrorGetConversations.value = true;
      print('Error loading conversations: $e');
    } finally {
      state.isLoadingConversations(false);
    }
  }

  Future<void> submitQuestion(String content, ChatAiChatState state) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    var answerId = state.uuid.v1();
    state.textController.clear();
    if (state.isUserAgri.value) {
      Question? latestQuestion;
      Answer? latestAnswer;

      if (state.getCurrentConversation.question != null &&
          state.getCurrentConversation.question!.isNotEmpty) {
        latestQuestion = state.getCurrentConversation.question!.last;
        if (latestQuestion.answer != null &&
            latestQuestion.answer!.isNotEmpty) {
          latestAnswer = latestQuestion.answer!.last;
        }
      }

      if (latestAnswer?.status == 'pending') {
        Answer? lastAnswer; // Nullable type

        // Update conversation and check for existing questions and answers
        state.updateConversation((val) {
          if (val.question != null && val.question!.isNotEmpty) {
            latestQuestion = val.question!.last;
            if (latestQuestion?.answer != null &&
                latestQuestion!.answer!.isNotEmpty) {
              lastAnswer = latestQuestion!.answer!.last;
              lastAnswer?.content = content;
              lastAnswer?.status = 'completed';
            }
          }
        });

        // Check if lastAnswer is not null before calling updateAnswer
        if (lastAnswer != null) {
          await provider.updateAnswer(
              lastAnswer?.id ?? '', lastAnswer?.content ?? content,
              status: lastAnswer?.status);
        }
      } else {
        Answer newAgriAnswer = Answer(
          id: answerId,
          questionId: latestQuestion?.id,
          content: content,
          status: 'completed',
          isLoading: false,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
          answerMedia: state.mediaAnswer.map((media) {
            media.id=state.uuid.v1();
            media.answerId = answerId;
            return media;
          }).toList(),
        );

        state.updateConversation((val) async {
          if (latestQuestion?.answer != null &&
              latestQuestion!.answer!.isNotEmpty) {
            latestQuestion?.answer ??= [];
            latestQuestion?.answer!.add(newAgriAnswer);
          }

          await provider.insertAnswer(newAgriAnswer, []);
        });
      }
      state.selectedMediaFiles.clear();
      state.selectedMediaQuestion.clear();
      state.mediaUploadProgress.clear();
      state.mediaAnswer.clear();
    } else {
      state.isLoadingAnswerAI.value = true;

      var questionId = state.uuid.v1();

      Question newQuestion = Question(
        id: questionId,
        conversationId: state.getCurrentConversation.id!,
        content: content,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        questionMedia: state.selectedMediaQuestion.map((media) {
          media.questionId = questionId;
          return media;
        }).toList(),
      );

      Answer aiAnswer = Answer(
        id: answerId,
        questionId: newQuestion.id,
        content: '',
        isLoading: true,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      if (state.isCurrentAgriConv()) {
        aiAnswer.status = 'pending';
        aiAnswer.isLoading = false;
      }
      state.updateConversation((val) {
        val.question ??= [];
        val.question!.add(newQuestion);
        newQuestion.answer ??= [];
        newQuestion.answer!.add(aiAnswer);
      });

      state.selectedMediaFiles.clear();
      state.selectedMediaQuestion.clear();
      state.mediaUploadProgress.clear();
      state.mediaAnswer.clear();
      simulateAIResponse(state);
    }
  }

  void simulateAIResponse(ChatAiChatState state) {
    Stream<String> aiResponseStream = simulateStreamingAPIResponse(state);
    _aiResponseSubscription = aiResponseStream.listen(
      (chunk) {
        state.updateConversation((val) {
          if (val.question != null && val.question!.isNotEmpty) {
            Question lastQuestion = val.question!.last;
            if (lastQuestion.answer != null &&
                lastQuestion.answer!.isNotEmpty) {
              Answer lastAnswer = lastQuestion.answer!.last;
              lastAnswer.content = (lastAnswer.content ?? '') + chunk;
            }
          }
        });
      },
      onError: (error) => handleAIResponseError(error, state),
      onDone: () => finalizeAIResponse(state),
      cancelOnError: true,
    );
  }

  void handleAIResponseError(dynamic error, ChatAiChatState state) {
    state.isLoadingAnswerAI.value = false;
    state.isErrorGetAnswer.value = true;
    state.updateConversation((val) {
      if (val.question != null && val.question!.isNotEmpty) {
        Question lastQuestion = val.question!.last;
        if (lastQuestion.answer != null && lastQuestion.answer!.isNotEmpty) {
          Answer lastAnswer = lastQuestion.answer!.last;
          lastAnswer.isError = true;
        }
      }
    });
  }

  void retryLastAction(ChatAiChatState state) {
    state.isLoadingAnswerAI.value = true;
    state.updateConversation((val) {
      if (val.question != null && val.question!.isNotEmpty) {
        Question lastQuestion = val.question!.last;
        if (lastQuestion.answer != null && lastQuestion.answer!.isNotEmpty) {
          Answer lastAnswer = lastQuestion.answer!.last;
          lastAnswer.isLoading = true;
          lastAnswer.isError = false;
        }
      }
    });
    simulateAIResponse(state);
  }

  void finalizeAIResponse(ChatAiChatState state) async {
    state.updateConversation((val) {
      if (val.question != null && val.question!.isNotEmpty) {
        Question lastQuestion = val.question!.last;
        if (lastQuestion.answer != null && lastQuestion.answer!.isNotEmpty) {
          lastQuestion.answer!.last.isLoading = false;
        }
      }
    });
    state.isLoadingAnswerAI.value = false;
    state.isErrorGetAnswer.value = false;

    Question? latestQuestion;
    Answer? latestAnswer;

    if (state.getCurrentConversation.question != null &&
        state.getCurrentConversation.question!.isNotEmpty) {
      latestQuestion = state.getCurrentConversation.question!.last;
      if (latestQuestion.answer != null && latestQuestion.answer!.isNotEmpty) {
        latestAnswer = latestQuestion.answer!.last;
      }
    }

    if (latestQuestion != null && latestAnswer != null) {
      await insertConversationDataIntoSupabase(
          latestQuestion, latestAnswer, state);
    }
  }

  Future<void> insertConversationDataIntoSupabase(
      Question question, Answer answer, ChatAiChatState state) async {
    try {
      if ((question.content?.isNotEmpty ?? false) &&
          (answer.content?.isNotEmpty ?? false)) {
        String conversationId;

        if (state.isDefaultConversation()) {
          String conversationTitle = (question.content!.length > 100)
              ? question.content!.substring(0, 100)
              : question.content!;
          conversationId =
              await provider.createConversation(conversationTitle, 'AI');

          state.updateConversation((val) {
            val.id = conversationId;
            val.title = conversationTitle;
          });

          state.updateDrawerList();
        } else {
          conversationId = state.getCurrentConversation.id!;
        }

        // Use the existing IDs for question and answer
        await provider.insertQuestionAndAnswer(
          conversationId: conversationId,
          questionId: question.id!, // Use existing question ID
          questionContent: question.content!,
          answerId: answer.id!, // Use existing answer ID
          answerContent: answer.content!,
          media: question.questionMedia ?? [],
          answerStatus: answer.status,
        );

        print('Conversation data successfully inserted into Supabase');
      } else {
        // Handle cases where question content or answer content is null or empty
        print('Question content or answer content is null or empty');
      }
    } catch (e) {
      print('Error inserting conversation data into Supabase: $e');
      // Handle the error appropriately, maybe show a snackbar to the user
    }
  }

  Stream<String> simulateStreamingAPIResponse(ChatAiChatState state) async* {
    // Check if appSetting is valid
    if (appSettingProvider.appSetting.value == null) {
      throw Exception('App settings not found');
    }

    final defaultAiModel = appSettingProvider.appSetting.value?.defaultAiModel;
    if (defaultAiModel == null) {
      throw Exception('Default AI model settings not found');
    }

    final company = defaultAiModel.company;
    if (company == null) {
      throw Exception('Company settings not found in AI model');
    }

    if (company.name == 'google') {
      // Use Gemini AI plugin for Google
      yield* streamFromGeminiAI(defaultAiModel, company.apiKey!,
          state.getCurrentConversation, state.selectedMediaFiles);
    } else {
      // Use default streaming method
      yield* streamFromHttpRequest(
        company.apiUrl!,
        company.apiKey!,
        defaultAiModel,
        state.getCurrentConversation,
      );
    }
  }

  void stopAIResponse() {
    _aiResponseSubscription?.cancel();
    finalizeAIResponse(Get.find<ChatAiChatState>());
  }

  Future<void> loadMoreConversations(ChatAiChatState state) async {
    if (state.isLoadingMore.value || !state.hasMoreConversations.value) return;
    try {
      state.isLoadingMore(true);
      state.currentPage++;
      final newConversations =
          await provider.getConversations(page: state.currentPage);
      state.listConversations.addAll(newConversations);
      state.hasMoreConversations(newConversations.length == 10);
      state.updateDrawerList();
    } catch (e) {
      print('Error loading more conversations: $e');
    } finally {
      state.isLoadingMore(false);
    }
  }

  Future<void> addNewConversation(String title, ChatAiChatState state) async {
    try {
      state.isLoading(true);
      state.setDefaultConversation();
      state.updateDrawerList();
    } catch (e) {
      print('Error adding new conversation: $e');
    } finally {
      state.isLoading(false);
    }
  }

  Future<void> loadQuestionsAndAnswers(ChatAiChatState state) async {
    if (state.currentConversation.value?.id != null &&
        (state.currentConversation.value?.question?.isEmpty ?? true)) {
      state.isLoadingQuestions.value = true;
      try {
        final questions = await provider.getListQuestionAnswerByConversationId(
            state.currentConversation.value!.id!);
        state.updateConversation((val) {
          val.question = questions;
        });
      } catch (e) {
        state.isErrorGetQuestionAnswer.value = true;
        state.isLoadingQuestions.value = false;
        Get.snackbar(
          'Error',
          'Error loading questions and answers: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        print('Error loading questions and answers: $e');
      } finally {
        state.isLoadingQuestions.value = false;
      }
    }
  }

  Future<void> pickMultipleMedia(ChatAiChatState state) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp3', 'wav'],
      allowMultiple: true,
    );

    if (result != null) {
      state.selectedMediaFiles
          .addAll(result.paths.map((path) => File(path!)).toList());
      state.mediaUploadProgress.addAll(List.filled(result.files.length, 0.0));
      simulateMediaUpload(state);
    }
  }

  void simulateMediaUpload(ChatAiChatState state) async {
    if (state.selectedMediaFiles.isEmpty) return;

    final userId = MyHive.getCurrentUser()?.id;
    const bucket = 'chat';

    for (int i = 0; i < state.selectedMediaFiles.length; i++) {
      if (state.mediaUploadProgress[i] == 1) continue;

      final file = state.selectedMediaFiles[i];
      try {
        final fileName = file.uri.pathSegments.last;
        final filePath =
            '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

        for (int progress = 0; progress <= 10; progress++) {
          await Future.delayed(const Duration(milliseconds: 50));
          state.mediaUploadProgress[i] = progress / 100;
        }

        final response = await Supabase.instance.client.storage
            .from(bucket)
            .upload(filePath, file);

        final fileUrl = Supabase.instance.client.storage
            .from(bucket)
            .getPublicUrl(filePath);

        for (int progress = 70; progress <= 100; progress++) {
          await Future.delayed(const Duration(milliseconds: 50));
          state.mediaUploadProgress[i] = progress / 100;
        }
        print('File uploaded successfully: $fileUrl');

        if (state.isUserClient.value) {
          final questionMedia = QuestionMedia(
            mediaUrl: fileUrl,
            mediaType: "Image",
          );

          state.selectedMediaQuestion.add(questionMedia);
        } else {
          final answerMedia = AnswerMedia(
            mediaUrl: fileUrl,
            mediaType: "Image",
          );

          state.mediaAnswer.add(answerMedia);
        }

        state.isLoadingUploadMedia.value = false;
      } catch (e) {
        print('Exception during upload: $e');
      } finally {
        state.isLoadingUploadMedia.value = false;
      }
    }
  }

  void removeSelectedMedia(int index, ChatAiChatState state) {
    if (index < 0 || index >= state.selectedMediaFiles.length) return;

    state.selectedMediaFiles.removeAt(index);

    if (state.isUserClient.value) {
      state.selectedMediaQuestion.removeAt(index);
    } else {
      state.mediaAnswer.removeAt(index);
    }
  }

  Stream<String> streamFromGeminiAI(
    DefaultAiModel defaultAiModel,
    String apiKey,
    Conversation currentConversation,
    List<File> selectedMediaFiles,
  ) async* {
    final model = GenerativeModel(
      model: defaultAiModel.modelCode!,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: defaultAiModel.temperature ?? 0.7,
        topP: defaultAiModel.topP ?? 0.7,
        topK: defaultAiModel.topK ?? 50,
        maxOutputTokens: defaultAiModel.maxTokens ?? 512,
      ),
    );

    final prompt = currentConversation.question!.last.content!;
    List<Uint8List> imageBytesList = [];
    for (var file in selectedMediaFiles) {
      try {
        final bytes = await file.readAsBytes();
        imageBytesList.add(bytes);
      } catch (e) {
        print('Error reading file ${file.path}: $e');
      }
    }

    final content = [
      Content.multi([
        TextPart(prompt),
        ...imageBytesList.map((bytes) => DataPart('image/jpeg', bytes))
      ])
    ];

    try {
      final responses = model.generateContentStream(content);
      await for (final response in responses) {
        final text = response.text;
        if (text != null && text.isNotEmpty) {
          yield text;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error in Gemini AI: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      yield* Stream.error('Error in Gemini AI streaming: $e');
    }
  }

  Stream<String> streamFromHttpRequest(
    String apiUrl,
    String apiKey,
    DefaultAiModel defaultAiModel,
    Conversation currentConversation,
  ) async* {
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json'
    };

    List<Map<String, String>> messages = [
      {
        "role": "system",
        "content": appSettingProvider.appSetting.value?.defaultMessage ?? ''
      }
    ];
    for (var q in currentConversation.question ?? []) {
      messages.add({"role": "user", "content": q.content ?? ''});
      for (var a in q.answer ?? []) {
        messages.add({"role": "assistant", "content": a.content ?? ''});
      }
    }

    final body = json.encode({
      "model": defaultAiModel.modelCode ?? '',
      "messages": messages,
      "max_tokens": defaultAiModel.maxTokens ?? 512,
      "temperature": defaultAiModel.temperature ?? 0.7,
      "top_p": defaultAiModel.topP ?? 0.7,
      "top_k": defaultAiModel.topK ?? 50,
      "repetition_penalty": defaultAiModel.repetitionPenalty ?? 1,
      "stop": defaultAiModel.stop ?? ["[/INST]", "</s>"],
      "stream": defaultAiModel.stream ?? true
    });

    final request = http.Request('POST', Uri.parse(apiUrl))
      ..headers.addAll(headers)
      ..body = body;

    final response = await request.send();

    if (response.statusCode == 200) {
      String accumulatedData = '';
      await for (var chunk in response.stream.transform(utf8.decoder)) {
        accumulatedData += chunk;
        final lines = accumulatedData.split('\n');
        for (var line in lines) {
          if (line.startsWith('data: ')) {
            final jsonString = line.substring(6);
            if (jsonString == '[DONE]') {
              return;
            }
            try {
              final decodedData = json.decode(jsonString);
              if (decodedData is Map && decodedData.containsKey('choices')) {
                final choices = decodedData['choices'];
                for (var choice in choices) {
                  if (choice.containsKey('delta') &&
                      choice['delta'].containsKey('content')) {
                    final content = choice['delta']['content'];
                    yield content;
                  }
                }
              }
            } catch (e) {
              continue;
            }
          }
        }
        accumulatedData = lines.last;
      }
    } else {
      throw Exception('Failed to load AI response');
    }
  }

  Future<void> fetchAgriConversations(ChatAiChatState state) async {
    final conversations = await provider.getAgriExpertConversations();
    state.listAgriConversations.assignAll(conversations);
  }
}
