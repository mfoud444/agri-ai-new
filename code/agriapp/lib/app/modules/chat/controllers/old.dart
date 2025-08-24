
// i have long code in chat_ai_chat_controller.dart below , how to make the ChatAiChatController code more manageable and readable, you can split it into smaller files that group related methods, states, and utilities you can refactor the code, write full code for all files when get answer..can split to chat_ai_chat_controller.dart, chat_ai_chat_state.dart, services/chat_ai_chat_service.dart, chat_ai_chat_utils.dart


// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:agri_ai/app/controllers/auth_controller.dart';
// import 'package:agri_ai/app/data/models/app_setting_model.dart';
// import 'package:agri_ai/app/data/models/conversation_model.dart';
// import 'package:agri_ai/app/data/providers/app_setting_provider.dart';
// import 'package:agri_ai/app/data/providers/conversation_provider.dart';
// import 'package:agri_ai/app/modules/chat/views/widgets/chat_drawer/chat_drawer.dart';
// import 'package:agri_ai/app/modules/chat/views/widgets/messages_view.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uuid/uuid.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:file_picker/file_picker.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:speech_to_text/speech_recognition_result.dart';

// class ChatAiChatController extends GetxController {

//   final ConversationProvider provider =  Get.find();
//   late final AppSettingProvider appSettingProvider;
//   final AuthController authController = Get.find();
//   final TextEditingController textController = TextEditingController();
//   final ScrollController scrollController = ScrollController();
//   final uuid = const Uuid();
//   final isTextEmpty = true.obs;
  

//   final isRecording = false.obs;
//   final isPaused = false.obs;

//   final isLoadingAnswerAI = false.obs;
//   final isLoadingQuestions = false.obs;
//   final isLoading = true.obs;
//   final isLoadingUploadMedia = false.obs;
//   final isLoadingConversations = true.obs;
//   final isLoadingMore = false.obs;
//   final hasMoreConversations = true.obs;
//   final isErrorGetAnswer = false.obs;
//   final isErrorGetQuestionAnswer = false.obs;


//   final isListening = false.obs;
//   final speechText = ''.obs;
//   late stt.SpeechToText _speech;


//   final listConversations = <Conversation>[].obs;
//   final currentConversation = Rxn<Conversation>();
//   final selectedMediaQuestion = <QuestionMedia>[].obs;
//   final selectedMediaFiles = <File>[].obs;
//   final mediaUploadProgress = <double>[].obs;
//   final drawerList = <DrawerList>[].obs;

//   final isLoadingAgriConversations = true.obs;
//   final listAgriConversations = <Conversation>[].obs;

//   int currentPage = 1;

//   StreamSubscription<String>? _aiResponseSubscription;

//   Conversation get defaultAIConversation => Conversation(
//         id: '',
//         userId: 'default_user',
//         title: 'New Conversation',
//         createdAt: DateTime.now().toIso8601String(),
//         updatedAt: DateTime.now().toIso8601String(),
//         type: 'AI',
//         question: [],
//       );



// late Conversation agriConversation;


//   @override
//   void onInit() {
//     super.onInit();
//      appSettingProvider = Get.find();
//     _speech = stt.SpeechToText();
//     // initializeAISetup();
//     _initSpeech();
//   }

//   Future<void> initializeAISetup() async {
//     textController.addListener(_updateTextEmpty);
//     SystemChannels.textInput.invokeMethod('TextInput.hide');
//       isLoadingAnswerAI.value = false;
//    isLoadingQuestions.value = false;
//    isLoading.value = true;
//    isLoadingUploadMedia.value = false;
//    isLoadingConversations.value = true;
//    isLoadingMore.value = false;
//    hasMoreConversations.value = true;
//    isErrorGetAnswer.value = false;
 
//  isErrorGetQuestionAnswer.value = false;
   

//    isListening.value = false;
//    speechText.value = '';
//     setDefaultConversation();
//     ever(listConversations, (_) => scrollToBottom());
//     await loadConversations();
//   }

//   Future<void> initializeAgriSetup() async {
//     textController.addListener(_updateTextEmpty);
//     SystemChannels.textInput.invokeMethod('TextInput.hide');
//        isLoadingAnswerAI.value = false;
//    isLoadingQuestions.value = false;
//    isLoading.value = true;
//    isLoadingUploadMedia.value = false;
//    isLoadingConversations.value = true;
//    isLoadingMore.value = false;
//    hasMoreConversations.value = true;
//    isErrorGetAnswer.value = false;
 
//  isErrorGetQuestionAnswer.value = false;
   

//    isListening.value = false;
//    speechText.value = '';
   

//      if (!isUserAgri()) {
//          agriConversation = appSettingProvider.agriConversation.value;
//     setCurrentConversation(agriConversation);
//     loadQuestionsAndAnswers();
//     } else {
//      isLoadingAgriConversations.value = true;
//      await fetchAgriConversations();
//      isLoadingAgriConversations.value = false;
//     }
//   }

//   void _initSpeech() async {
//     bool available = await _speech.initialize();
//     if (available) {
//       // Speech recognition is available
//     } else {
//       // Speech recognition is not available
//     }
//   }

//   void _startListening() async {
//     isListening.value = true;
//     await _speech.listen(
//       onResult: _onSpeechResult,
//       cancelOnError: true,
//       partialResults: true,
//     );
//   }

//   void _stopListening() async {
//     await _speech.stop();
//     isListening.value = false;
//   }

//   void _onSpeechResult(SpeechRecognitionResult result) {
//     speechText.value = result.recognizedWords;
//     textController.text = speechText.value;
//     // _updateTextEmpty();
//   }


//   void toggleListening() {
//     if (isListening.value) {
//       _stopListening();
//     } else {
//       _startListening();
//     }
//   }


//  Future<void> fetchAgriConversations() async {
//       final conversations = await provider.getAgriExpertConversations();
//       listAgriConversations.assignAll(conversations);
//  }

 

//  void getQuestionAndAnswerAgri(Conversation conv) async {
//         setCurrentConversation(conv);
//         loadQuestionsAndAnswers();
//         Get.to(() => MessagesView());
//   }

//   @override
//   Future<void> onReady() async {
//     super.onReady();
   
//   }

//   void _updateTextEmpty() => isTextEmpty.value = textController.text.isEmpty;

//   void setCurrentConversation(Conversation conversation) {
//     currentConversation.value = conversation;
//   }



//   bool isDefaultConversation() => currentConversation.value?.id == '';
//   bool isCurrentAgriConv() => currentConversation.value?.type == 'Agri-Expert';

//   bool isNotEnableButtonSend() {
//     return isErrorGetAnswer.value 
//     || isLoadingAnswerAI.value
//          || isTextEmpty.value
//         || isLoadingUploadMedia.value || isErrorGetQuestionAnswer.value;
//   }

//   void setDefaultConversation() {
//     if (!listConversations.any((c) => c.id == defaultAIConversation.id)) {
//       listConversations.add(defaultAIConversation);
//     }
//     setCurrentConversation(defaultAIConversation);
//   }

//   Conversation get getCurrentConversation =>
//       currentConversation.value ?? defaultAIConversation;

//   void updateConversation(void Function(Conversation) updater) {
//     currentConversation.update((val) {
//       if (val != null) {
//         updater(val);
//         int index = listConversations.indexWhere((c) => c.id == val.id);
//         if (index != -1) {
//           listConversations[index] = val;
//           listConversations.refresh();
//         }
//       }
//     });
//   }

//   String getMediaType(String extension) {
//     switch (extension) {
//       case 'jpg':
//       case 'jpeg':
//       case 'png':
//       case 'gif':
//         return 'image';
//       case 'mp3':
//       case 'wav':
//       case 'm4a':
//         return 'audio';
//       default:
//         return 'unknown';
//     }
//   }

//   bool isUserAgri() {
//     return authController.isUserAgri();
//   }

//   void submitQuestion(String content) async {
//     SystemChannels.textInput.invokeMethod('TextInput.hide');
//     scrollToBottom();
//     var answerId = uuid.v1();
//     textController.clear();
//     if (isUserAgri()) {
     
//        Question? lastQuestion;
//     Answer? lastAnswer; // Nullable type

//     // Update conversation and check for existing questions and answers
//     updateConversation((val) {
//       if (val.question != null && val.question!.isNotEmpty) {
//         lastQuestion = val.question!.last;
//         if (lastQuestion?.answer != null && lastQuestion!.answer!.isNotEmpty) {
//           lastAnswer = lastQuestion!.answer!.last;
//           lastAnswer?.content = content;
//           lastAnswer?.status = 'Complete';
//         }
//       }
//     });

//     // Check if lastAnswer is not null before calling updateAnswer
//     if (lastAnswer != null) {
//       await provider.updateAnswer(lastAnswer?.id ?? '', lastAnswer?.content ?? content, status: lastAnswer?.status);
//     }
  
//         selectedMediaFiles.clear();
        
      
//     } else {
//       isLoadingAnswerAI.value = true;

//       var questionId = uuid.v1();

//       Question newQuestion = Question(
//         id: questionId,
//         conversationId: getCurrentConversation.id!,
//         content: content,
//         createdAt: DateTime.now().toIso8601String(),
//         updatedAt: DateTime.now().toIso8601String(),
//         questionMedia: selectedMediaQuestion.map((media) {
//           media.questionId = questionId;
//           return media;
//         }).toList(),
//       );

//       Answer aiAnswer = Answer(
//         id: answerId,
//         questionId: newQuestion.id,
//         content: '',
//         isLoading: true,
//         createdAt: DateTime.now().toIso8601String(),
//         updatedAt: DateTime.now().toIso8601String(),
//       );
//       if (isCurrentAgriConv()) {
//         aiAnswer.status = 'pending';
//         aiAnswer.isLoading = false;
//       }
//       updateConversation((val) {
//         val.question ??= [];
//         val.question!.add(newQuestion);
//         newQuestion.answer ??= [];
//         newQuestion.answer!.add(aiAnswer);
//       });

//       selectedMediaFiles.clear();

//       simulateAIResponse();
//     }
//   }

//   void simulateAIResponse() {
//     Stream<String> aiResponseStream = simulateStreamingAPIResponse();
//     _aiResponseSubscription = aiResponseStream.listen(
//       (chunk) {
//         updateConversation((val) {
//           if (val.question != null && val.question!.isNotEmpty) {
//             Question lastQuestion = val.question!.last;
//             if (lastQuestion.answer != null &&
//                 lastQuestion.answer!.isNotEmpty) {
//               Answer lastAnswer = lastQuestion.answer!.last;
//               lastAnswer.content = (lastAnswer.content ?? '') + chunk;
//             }
//           }
//         });
//         scrollToBottom();
//       },
//       onError: (error) => handleAIResponseError(error),
//       onDone: () => finalizeAIResponse(),
//       cancelOnError: true,
//     );
//   }

//   void handleAIResponseError(dynamic error) {
//     isLoadingAnswerAI.value = false;
//     isErrorGetAnswer.value = true;
//     updateConversation((val) {
//       if (val.question != null && val.question!.isNotEmpty) {
//         Question lastQuestion = val.question!.last;
//         if (lastQuestion.answer != null && lastQuestion.answer!.isNotEmpty) {
//           Answer lastAnswer = lastQuestion.answer!.last;
//           lastAnswer.isError = true;
//         }
//       }
//     });
//   }

//   void retryLastAction() {
//     isLoadingAnswerAI.value = true;
//     updateConversation((val) {
//       if (val.question != null && val.question!.isNotEmpty) {
//         Question lastQuestion = val.question!.last;
//         if (lastQuestion.answer != null && lastQuestion.answer!.isNotEmpty) {
//           Answer lastAnswer = lastQuestion.answer!.last;
//           lastAnswer.isLoading = true;
//           lastAnswer.isError = false;
//         }
//       }
//     });
//     simulateAIResponse();
//   }

//   void finalizeAIResponse() async {
//     updateConversation((val) {
//       if (val.question != null && val.question!.isNotEmpty) {
//         Question lastQuestion = val.question!.last;
//         if (lastQuestion.answer != null && lastQuestion.answer!.isNotEmpty) {
//           lastQuestion.answer!.last.isLoading = false;
//         }
//       }
//     });
//     isLoadingAnswerAI.value = false;
//     isErrorGetAnswer.value = false;
//     scrollToBottom();

//     // Get the latest question and answer
//     Question? latestQuestion;
//     Answer? latestAnswer;

//     if (getCurrentConversation.question != null &&
//         getCurrentConversation.question!.isNotEmpty) {
//       latestQuestion = getCurrentConversation.question!.last;
//       if (latestQuestion.answer != null && latestQuestion.answer!.isNotEmpty) {
//         latestAnswer = latestQuestion.answer!.last;
//       }
//     }

//     // Insert conversation data into Supabase
//     if (latestQuestion != null && latestAnswer != null) {
//       await insertConversationDataIntoSupabase(latestQuestion, latestAnswer);
//     }
//   }

//   Future<void> insertConversationDataIntoSupabase(
//       Question question, Answer answer) async {
//     try {
//       if ((question.content?.isNotEmpty ?? false) &&
//           (answer.content?.isNotEmpty ?? false)) {
//         String conversationId;

//         if (isDefaultConversation()) {
//           String conversationTitle = (question.content!.length > 100)
//               ? question.content!.substring(0, 100)
//               : question.content!;
//           conversationId =
//               await provider.createConversation(conversationTitle, 'AI');

//           updateConversation((val) {
//             val.id = conversationId;
//             val.title = conversationTitle;
//           });

//           updateDrawerList();
//         } else {
//           conversationId = getCurrentConversation.id!;
//         }

//         // Use the existing IDs for question and answer
//         await provider.insertQuestionAndAnswer(
//           conversationId: conversationId,
//           questionId: question.id!, // Use existing question ID
//           questionContent: question.content!,
//           answerId: answer.id!, // Use existing answer ID
//           answerContent: answer.content!,
//           media: question.questionMedia ?? [],
//           answerStatus: answer.status,
//         );

//         print('Conversation data successfully inserted into Supabase');
//       } else {
//         // Handle cases where question content or answer content is null or empty
//         print('Question content or answer content is null or empty');
//       }
//     } catch (e) {
//       print('Error inserting conversation data into Supabase: $e');
//       // Handle the error appropriately, maybe show a snackbar to the user
//     }
//   }

//   void scrollToBottom() {
//     if (scrollController.hasClients) {
//       scrollController.animateTo(
//         scrollController.position.maxScrollExtent,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

// // Function to handle streaming based on company name
//   Stream<String> simulateStreamingAPIResponse() async* {
//     // Check if appSetting is valid
//     if (appSettingProvider.appSetting.value == null) {
//       throw Exception('App settings not found');
//     }

//     final defaultAiModel = appSettingProvider.appSetting.value?.defaultAiModel;
//     if (defaultAiModel == null) {
//       throw Exception('Default AI model settings not found');
//     }

//     final company = defaultAiModel.company;
//     if (company == null) {
//       throw Exception('Company settings not found in AI model');
//     }

//     if (company.name == 'google') {
//       // Use Gemini AI plugin for Google
//       yield* streamFromGeminiAI(
//         defaultAiModel,
//         company.apiKey!,
//         getCurrentConversation,
//       );
//     } else {
//       // Use default streaming method
//       yield* streamFromHttpRequest(
//         company.apiUrl!,
//         company.apiKey!,
//         defaultAiModel,
//         getCurrentConversation,
//       );
//     }
//   }

//   Stream<String> streamFromGeminiAI(
//     DefaultAiModel defaultAiModel,
//     String apiKey,
//     Conversation currentConversation,
//   ) async* {
//     // Initialize the GenerativeModel
//     final model = GenerativeModel(
//       model: defaultAiModel.modelCode!,
//       apiKey: apiKey,
//       generationConfig: GenerationConfig(
//         temperature: defaultAiModel.temperature ?? 0.7,
//         topP: defaultAiModel.topP ?? 0.7,
//         topK: defaultAiModel.topK ?? 50,
//         maxOutputTokens: defaultAiModel.maxTokens ?? 512,
//       ),
//     );

//     // Prepare the prompt
//     final prompt = currentConversation.question!.last.content!;
//     print('Prompt: $prompt');

//     // Read image files as byte lists
//     List<Uint8List> imageBytesList = [];
//     for (var file in selectedMediaFiles) {
//       try {
//         final bytes = await file.readAsBytes();
//         imageBytesList.add(bytes);
//       } catch (e) {
//         print('Error reading file ${file.path}: $e');
//       }
//     }

//     // Create content to send to the model
//     final content = [
//       Content.multi([
//         TextPart(prompt),
//         // The only accepted mime types are image/*.
//         ...imageBytesList.map((bytes) => DataPart('image/jpeg', bytes))
//       ])
//     ];

//     try {
//       final responses = model.generateContentStream(content);

//       await for (final response in responses) {
//         final text = response.text;
//         if (text != null && text.isNotEmpty) {
//           yield text;
//         }
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Error in Gemini AI: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//         duration: Duration(seconds: 3),
//       );
//       yield* Stream.error('Error in Gemini AI streaming: $e');
//     }
//   }

//   Stream<String> streamFromHttpRequest(
//     String apiUrl,
//     String apiKey,
//     DefaultAiModel defaultAiModel,
//     Conversation currentConversation,
//   ) async* {
//     final headers = {
//       'Authorization': 'Bearer $apiKey',
//       'Content-Type': 'application/json'
//     };

//     // Build the message history
//     List<Map<String, String>> messages = [
//       {
//         "role": "system",
//         "content": appSettingProvider.appSetting.value?.defaultMessage ?? ''
//       }
//     ];
//     for (var q in currentConversation.question ?? []) {
//       messages.add({"role": "user", "content": q.content ?? ''});
//       for (var a in q.answer ?? []) {
//         messages.add({"role": "assistant", "content": a.content ?? ''});
//       }
//     }

//     final body = json.encode({
//       "model": defaultAiModel.modelCode ?? '',
//       "messages": messages,
//       "max_tokens": defaultAiModel.maxTokens ?? 512,
//       "temperature": defaultAiModel.temperature ?? 0.7,
//       "top_p": defaultAiModel.topP ?? 0.7,
//       "top_k": defaultAiModel.topK ?? 50,
//       "repetition_penalty": defaultAiModel.repetitionPenalty ?? 1,
//       "stop": defaultAiModel.stop ?? ["[/INST]", "</s>"],
//       "stream": defaultAiModel.stream ?? true
//     });

//     final request = http.Request('POST', Uri.parse(apiUrl))
//       ..headers.addAll(headers)
//       ..body = body;

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       String accumulatedData = '';
//       await for (var chunk in response.stream.transform(utf8.decoder)) {
//         accumulatedData += chunk;
//         final lines = accumulatedData.split('\n');
//         for (var line in lines) {
//           if (line.startsWith('data: ')) {
//             final jsonString = line.substring(6);
//             if (jsonString == '[DONE]') {
//               return;
//             }
//             try {
//               final decodedData = json.decode(jsonString);
//               if (decodedData is Map && decodedData.containsKey('choices')) {
//                 final choices = decodedData['choices'];
//                 for (var choice in choices) {
//                   if (choice.containsKey('delta') &&
//                       choice['delta'].containsKey('content')) {
//                     final content = choice['delta']['content'];
//                     yield content;
//                   }
//                 }
//               }
//             } catch (e) {
//               continue;
//             }
//           }
//         }
//         accumulatedData = lines.last;
//       }
//     } else {
//       throw Exception('Failed to load AI response');
//     }
//   }

//   bool isImageAllow() {
//     final defaultAiModel = appSettingProvider.appSetting.value?.defaultAiModel;
//     return (defaultAiModel?.inputData?.contains('Image') ?? false || isCurrentAgriConv()) ;
//   }

//   bool isAudioAllow() {
//     final defaultAiModel = appSettingProvider.appSetting.value?.defaultAiModel;
//     return (defaultAiModel?.inputData?.contains('Audio') ?? false || isCurrentAgriConv()) ;
//   }


//   void stopAIResponse() {
//     _aiResponseSubscription?.cancel();
//     finalizeAIResponse();
//   }


//   Future<void> loadConversations() async {
//     try {
//       isLoadingConversations(true);
//       final newConversations =
//           await provider.getConversations(page: currentPage);
//       listConversations.addAll(newConversations);
//       hasMoreConversations(newConversations.length == 10);
//       updateDrawerList();
//     } catch (e) {
//       print('Error loading conversations: $e');
//     } finally {
//       isLoadingConversations(false);
//     }
//   }

//   Future<void> loadMoreConversations() async {
//     if (isLoadingMore.value || !hasMoreConversations.value) return;
//     try {
//       isLoadingMore(true);
//       currentPage++;
//       final newConversations =
//       await provider.getConversations(page: currentPage);
//       listConversations.addAll(newConversations);
//       hasMoreConversations(newConversations.length == 10);
//       updateDrawerList();
//     } catch (e) {
//       print('Error loading more conversations: $e');
//     } finally {
//       isLoadingMore(false);
//     }
//   }

//   void updateDrawerList() {
//     drawerList.value = listConversations
//         .where((conversation) =>
//             conversation.id != null && conversation.id!.isNotEmpty)
//         .map((conversation) => DrawerList(
//               index: DrawerIndex.ChatAiChatView,
//               labelName: conversation.title ?? 'New Chat',
//               icon: const Icon(Icons.chat),
//               imageName: '',
//               id: conversation.id!,
//             ))
//         .toList();
//   }

//   Future<void> addNewConversation(String title) async {
//     try {
//       isLoading(true);
//       setDefaultConversation();
//       // final newConversation = await provider.addNewConversation(title);
//       // listConversations.insert(0, );
//       // setCurrentConversation(newConversation);
//       updateDrawerList();
//     } catch (e) {
//       print('Error adding new conversation: $e');
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> loadQuestionsAndAnswers() async {
//     if (currentConversation.value?.id != null &&
//         (currentConversation.value?.question?.isEmpty ?? true)) {
//       isLoadingQuestions.value = true;
//       try {
//         final questions = await provider.getListQuestionAnswerByConversationId(
//             currentConversation.value!.id!);
//         updateConversation((val) {
//           val.question = questions;
//         });

//     //     if(isUserAgri()){
//     //        Question? latestQuestion;
//     // Answer? latestAnswer;
//     //         if (getCurrentConversation.question != null &&
//     //     getCurrentConversation.question!.isNotEmpty) {
//     //   latestQuestion = getCurrentConversation.question!.last;
//     //   if (latestQuestion.answer == null || latestQuestion.answer!.isEmpty) {
//     //     latestAnswer = latestQuestion.answer!.last;
//     //   }
//     // }
//     //     }
//       } catch (e) {
      
//         isErrorGetQuestionAnswer.value = true;
//         print('Error loading questions and answers: $e');
//       } finally {
//         isLoadingQuestions.value = false;
//       }
//     }
//   }

   

//   Future<void> pickMultipleMedia() async {
//     final ImagePicker picker = ImagePicker();
//     final FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'jpeg', 'png', 'mp3', 'wav'],
//       allowMultiple: true,
//     );

//     if (result != null) {
//       selectedMediaFiles
//           .addAll(result.paths.map((path) => File(path!)).toList());
//       mediaUploadProgress.addAll(List.filled(result.files.length, 0.0));
//       simulateMediaUpload();
//     }
//   }

//   void simulateMediaUpload() async {
//     if (selectedMediaFiles.isEmpty) return;
//     isLoadingUploadMedia.value = true;
//     final userId = Get.find<ConversationProvider>().userId;
//     const bucket = 'chat';

//     for (int i = 0; i < selectedMediaFiles.length; i++) {
//       if(mediaUploadProgress[i] == 1)    continue;

//       final file = selectedMediaFiles[i];
//       try {
//         final fileName = file.uri.pathSegments.last;
//         final filePath =
//             '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

//         for (int progress = 0; progress <= 10; progress++) {
//           await Future.delayed(Duration(milliseconds: 50));
//           mediaUploadProgress[i] = progress / 100;
//         }

//         final response = await Supabase.instance.client.storage
//             .from(bucket)
//             .upload(filePath, file);

//         final fileUrl = Supabase.instance.client.storage
//             .from(bucket)
//             .getPublicUrl(filePath);

//         for (int progress = 70; progress <= 100; progress++) {
//           await Future.delayed(Duration(milliseconds: 50));
//           mediaUploadProgress[i] = progress / 100;
//         }
//         print('File uploaded successfully: $fileUrl');

//         // Create QuestionMedia object with uploaded file info
//         final questionMedia = QuestionMedia(
//           mediaUrl: fileUrl,
//           mediaType: "Image",
//         );

//         // Add to the list
//         selectedMediaQuestion.add(questionMedia);
//         isLoadingUploadMedia.value = false;
//       } catch (e) {
//         print('Exception during upload: $e');
//       }
      
//     }
//   }

//   void removeSelectedMedia(int index) {
//     if (index < 0 || index >= selectedMediaFiles.length) return;

//     final fileToRemove = selectedMediaFiles[index];
//     selectedMediaFiles.removeAt(index);
//     selectedMediaQuestion.removeAt(index);
//   }
// }
