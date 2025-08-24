import 'package:flutter/material.dart';
import 'chat_ai_chat_state.dart';

class ChatAiChatUtils {

  void initUtils() {
    // Initialize any utils-specific setup here
  }

  void scrollToBottom(ScrollController scrollController) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String getMediaType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'image';
      case 'mp3':
      case 'wav':
      case 'm4a':
        return 'audio';
      default:
        return 'unknown';
    }
  }

 




  void handleSpeechToText(ChatAiChatState state) async {
    if (state.isListening.value) {
      await state.speech.stop();
      state.isListening.value = false;
    } else {
      bool available = await state.speech.initialize();
      if (available) {
        state.isListening.value = true;
        await state.speech.listen(
          onResult: (result) {
            state.speechText.value = result.recognizedWords;
            state.textController.text = state.speechText.value;
          },
          cancelOnError: true,
          partialResults: true,
        );
      }
    }
  }
}