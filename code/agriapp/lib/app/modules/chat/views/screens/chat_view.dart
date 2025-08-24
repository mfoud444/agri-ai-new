import 'package:agri_ai/app/modules/chat/views/screens/main_chat_agri_view.dart';
import 'package:agri_ai/app/modules/chat/views/screens/main_chat_ai_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';

class ChatView extends GetView<ChatAiChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Obx(() {
          if (!controller.state.isCurrentAgriConv()) {
           
            if (controller.state.isUserAgri.value) {
              return const MainChatAgriView();
            } else {
              return const MainChatAiView();
            }
          } else {
            return const MainChatAgriView();
          }
        }),
      ),
    );
  }
}
