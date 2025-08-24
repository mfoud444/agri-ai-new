import 'dart:io';

import 'package:agri_ai/app/controllers/auth_controller.dart';
import 'package:agri_ai/app/data/local/my_hive.dart';
import 'package:agri_ai/app/data/providers/app_setting_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:uuid/uuid.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:agri_ai/app/data/models/conversation_model.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/chat_drawer/chat_drawer.dart';

class ChatAiChatState {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final uuid = const Uuid();
  final isTextEmpty = true.obs;

  final isRecording = false.obs;
  final isPaused = false.obs;
  final isLoadingAnswerAI = false.obs;
  final isLoadingQuestions = false.obs;
  final isLoading = true.obs;
  final isLoadingUploadMedia = false.obs;
  final isLoadingConversations = true.obs;
  final isLoadingMore = false.obs;
  final hasMoreConversations = true.obs;
  final isErrorGetAnswer = false.obs;
  final isErrorGetQuestionAnswer = false.obs;

  final isListening = false.obs;
  final speechText = ''.obs;
  late stt.SpeechToText speech;

  final listConversations = <Conversation>[].obs;
  final currentConversation = Rxn<Conversation>();
  final selectedMediaQuestion = <QuestionMedia>[].obs;
    final mediaAnswer = <AnswerMedia>[].obs;
  final selectedMediaFiles = <File>[].obs;
  final mediaUploadProgress = <double>[].obs;
  final drawerList = <DrawerList>[].obs;

 final isErrorGetConversations = false.obs;
  final isLoadingAgriConversations = true.obs;
  final listAgriConversations = <Conversation>[].obs;

final showChatMessageUserToAgri = false.obs;
  int currentPage = 1;
 final nameHeaderQuestion = 'You'.obs;
  final nameHeaderAnswer = 'AI'.obs;
late final AppSettingProvider appSettingProvider;
 final isUserAgri = false.obs;
  final isUserClient = false.obs;
late Conversation agriConversation;
  void initState() {
     updateUserType();
     appSettingProvider = Get.find();
    speech = stt.SpeechToText();
    
    _initSpeech();
  }

 // Reset state function
  void resetState() {
    // textController.clear();
    // scrollController.jumpTo(0.0);
    // isTextEmpty.value = true;

    isRecording.value = false;
    isPaused.value = false;

    //AI
    isLoadingAnswerAI.value = false;
    isLoadingQuestions.value = false;
    isLoading.value = true;
    isLoadingUploadMedia.value = false;
    isLoadingConversations.value = true;
    isLoadingMore.value = false;
    hasMoreConversations.value = true;
    isErrorGetAnswer.value = false;
    isErrorGetQuestionAnswer.value = false;

    isListening.value = false;
    speechText.value = '';
 
    // listConversations.clear();
    // currentConversation.value = null;
    // selectedMediaQuestion.clear();
    // selectedMediaFiles.clear();
    // mediaUploadProgress.clear();
    // drawerList.clear();

    isErrorGetConversations.value = false;
    isLoadingAgriConversations.value = true;
    listAgriConversations.clear();

    currentPage = 1;

    // Reinitialize speech recognition
    _initSpeech();
  }
  Conversation get defaultAIConversation => Conversation(
    id: '',
    userId: 'default_user',
    title: 'New Conversation',
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
    type: 'AI',
    question: [],
  );

  void setDefaultConversation() {
    if (!listConversations.any((c) => c.id == defaultAIConversation.id)) {
      listConversations.add(defaultAIConversation);
    }
    setCurrentConversation(defaultAIConversation);
  }

  void setCurrentConversation(Conversation conversation) {
    currentConversation.value = conversation;
  }

  Conversation get getCurrentConversation =>
      currentConversation.value ?? defaultAIConversation;

  void updateConversation(void Function(Conversation) updater) {
    currentConversation.update((val) {
      if (val != null) {
        updater(val);
        int index = listConversations.indexWhere((c) => c.id == val.id);
        if (index != -1) {
          listConversations[index] = val;
          listConversations.refresh();
        }
      }
    });
  }

  void updateDrawerList() {
    drawerList.value = listConversations
        .where((conversation) =>
            conversation.id != null && conversation.id!.isNotEmpty)
        .map((conversation) => DrawerList(
              index: DrawerIndex.ChatAiChatView,
              labelName: conversation.title ?? 'New Chat',
              icon: const Icon(Icons.chat),
              imageName: '',
              id: conversation.id!,
            ))
        .toList();
  }

    bool isDefaultConversation() => currentConversation.value?.id == '';
  bool isCurrentAgriConv() => currentConversation.value?.type == 'Agri-Expert';

    void updateUserType() {
    final userType = MyHive.getCurrentUser()?.userType;
    isUserAgri.value = userType == 'Agri-Expert';
    isUserClient.value = userType == 'Client';
  }

    bool isImageAllow() {
    final defaultAiModel = appSettingProvider.appSetting.value?.defaultAiModel;
    return (defaultAiModel?.inputData?.contains('Image') ?? false || isCurrentAgriConv()) ;
  }

  bool isAudioAllow() {
    final defaultAiModel = appSettingProvider.appSetting.value?.defaultAiModel;
    return (defaultAiModel?.inputData?.contains('Audio') ?? false || isCurrentAgriConv()) ;
  }

  bool isNotEnableButtonSend() {
    return isErrorGetAnswer.value 
      || isLoadingAnswerAI.value
      || isTextEmpty.value
      || isLoadingUploadMedia.value 
      || isErrorGetQuestionAnswer.value;
  }



  void _initSpeech() async {
    bool available = await speech.initialize();
    if (available) {
      // Speech recognition is available
    } else {
      // Speech recognition is not available
    }
  }

  void _startListening() async {
    isListening.value = true;
    await speech.listen(
      onResult: _onSpeechResult,
      cancelOnError: true,
      partialResults: true,
    );
  }

  void _stopListening() async {
    await speech.stop();
    isListening.value = false;
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    speechText.value = result.recognizedWords;
    textController.text = speechText.value;
    // _updateTextEmpty();
  }


  void toggleListening() {
    if (isListening.value) {
      _stopListening();
    } else {
      _startListening();
    }
  }












}