import 'package:get/get.dart';
import '../controllers/chat_ai_chat_controller.dart';

class ChatAiChatBinding extends Bindings {
  @override
  void dependencies() {
     
          Get.lazyPut<ChatAiChatController>(
      () => ChatAiChatController(),
    );


  }
}
