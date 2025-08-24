import 'package:agri_ai/app/data/models/conversation_model.dart';
import 'package:agri_ai/app/modules/chat/services/chat_ai_chat_service.dart';
import 'package:get/get.dart';
import 'chat_ai_chat_state.dart';
import 'chat_ai_chat_utils.dart';

class ChatAiChatController extends GetxController {
  final ChatAiChatState state = ChatAiChatState();
  final ChatAiChatService service = ChatAiChatService();
  final ChatAiChatUtils utils = ChatAiChatUtils();


  @override
  void onInit() {
    super.onInit();
    state.initState();
    service.initService();
    utils.initUtils();
  }


  Future<void> initializeAISetup() async {
   
    state.textController.addListener(_updateTextEmpty);
    state.setDefaultConversation();
    await service.loadConversations(state);
    ever(state.listConversations, (_) => utils.scrollToBottom(state.scrollController));
  }

  Future<void> initializeAgriSetup() async {
     state.textController.addListener(_updateTextEmpty);
     if (!state.isUserAgri()) {
      
      // state.currentConversation.value = null;
         state.agriConversation = state.appSettingProvider.agriConversation.value;
    state.setCurrentConversation(state.agriConversation);
   state.currentConversation.value?.type = 'Agri-Expert';

    loadQuestionsAndAnswers();
    } else {
     state.isLoadingAgriConversations.value = true;
     await  service.fetchAgriConversations(state);
     state.isLoadingAgriConversations.value = false;
    }
  }
  void _updateTextEmpty() => state.isTextEmpty.value = state.textController.text.isEmpty;

  void submitQuestion(String content) async {
    await service.submitQuestion(content, state);
    utils.scrollToBottom(state.scrollController);
  }

  void retryLastAction() {
    service.retryLastAction(state);
  }

  void stopAIResponse() {
    service.stopAIResponse();
  }

  Future<void> loadMoreConversations() async {
    await service.loadMoreConversations(state);
  }

  Future<void> addNewConversation(String title) async {
    await service.addNewConversation(title, state);
  }

  Future<void> loadQuestionsAndAnswers() async {
    await service.loadQuestionsAndAnswers(state);
  }

  Future<void> pickMultipleMedia() async {
    await service.pickMultipleMedia(state);
  }

  void removeSelectedMedia(int index) {
    service.removeSelectedMedia(index, state);
  }
   void getQuestionAndAnswerAgri(Conversation conv) async {
        state.setCurrentConversation(conv);
      await  service.loadQuestionsAndAnswers(state);
       
  }
}
