import 'package:agri_ai/app/data/local/my_hive.dart';
import 'package:agri_ai/app/data/models/conversation_model.dart';
import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/messages/audio_file_message.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/messages/image_grid_builder.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:agri_ai/app/data/models/user_model.dart' as local_user;
import 'package:intl/intl.dart';


class AnswerMessage extends GetView<ChatAiChatController> {
  final List<Answer> answers;

  AnswerMessage({
    super.key,
    required this.answers,
  });

  final FlutterTts flutterTts = FlutterTts();
  final RxBool isSpeaking = false.obs;
  final RxInt currentAnswerIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentAnswer = answers[currentAnswerIndex.value];
  
      local_user.User? currentUser = MyHive.getCurrentUser();
     const avatarUser = "AI";
 
   final createdAtString = currentAnswer.createdAt ?? '';

      DateTime? createdAt;
      try {
        createdAt = DateTime.parse(createdAtString);
      } catch (e) {
        createdAt = null;
      }

      String formattedDate = createdAt != null
          ? DateFormat('yyyy-MM-dd – HH:mm').format(createdAt)
          : '';


      return Container(
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if  (currentAnswer.status != null && controller.state.isCurrentAgriConv() && currentAnswer.status != 'completed') 
                 
              _buildStateWidget(currentAnswer.status!)
            else if (currentAnswer.isError ?? false)
              _buildErrorWidget()
            else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   CircleAvatar(
                    backgroundColor: Colors.green[100],
                    // backgroundImage: currentUser?.avatarUrl != null
                    //     ? NetworkImage(currentUser!.avatarUrl!)
                    //     : null,
                    child: const Text(avatarUser , style: TextStyle(color: Colors.black))
                      
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.state.nameHeaderAnswer.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(formattedDate,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 10)),
                             
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              AnimatedOpacity(
                opacity: currentAnswer.isLoading ?? false ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const LinearProgressIndicator(),
              ),
              const SizedBox(height: 4),
              MarkdownBody(
                data: currentAnswer.content ?? '',
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 15),
                ),
              ),
                  SizedBox(height: 4.h),
                    if (currentAnswer.answerMedia != null &&
                        currentAnswer.answerMedia!.isNotEmpty)
                      ...buildMediaWidgets(currentAnswer.answerMedia!),
              SizedBox(height: 7.h),
              if (!(currentAnswer.isLoading ?? false))
                _buildIconRow(context, answers.length > 1),
            ],
          ],
        ),
      );
    });
  }


  Widget _buildStateWidget(String status) {
    switch (status) {
      case 'pending':
        return _buildPendingWidget();
      case 'rejected':
        return _buildRejectedWidget();
      default:
        return const SizedBox.shrink();
    }
  }

   Widget _buildPendingWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
       
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/pending.png', height: 100.h),
              SizedBox(height: 20.h),
              Text(
                Strings.yourRequestIsPending.tr,
                style: TextStyle(fontSize: 18.sp, color: Colors.orange),
              ),
            ],
          ),
        ),
        SizedBox(height: 50.h),
      ],
    );
  }

  Widget _buildRejectedWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 50.h),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/rejected.png', height: 100.h),
              SizedBox(height: 20.h),
              Text(
                Strings.yourRequestHasBeenRejected.tr,
                style: TextStyle(fontSize: 18.sp, color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 50.h),
      ],
    );
  }

Widget _buildErrorWidget() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/errormessage.png', height: 100.h),
            SizedBox(height: 20.h),
            Text(
              Strings.sometimesThereIsAnError.tr,
              style: TextStyle(fontSize: 18.sp, color: Colors.red),
            ),
            SizedBox(height: 20.h),  // Add some space between the error text and button
            ElevatedButton(
              onPressed: () {
                // Call a method to retry the action
                controller.retryLastAction(); // Implement this method in your controller
              },
              child:  Text(Strings.retry.tr),
            ),
          ],
        ),
      ),
      SizedBox(height: 50.h),
    ],
  );
}


  Widget _buildIconRow(BuildContext context, bool showNavigationButtons) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 230, 240, 227),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showNavigationButtons)
            _buildIconButton(
              Icons.arrow_back,
              Strings.previous.tr,
              () => _changeAnswer(-1),
              enabled: currentAnswerIndex.value > 0,
            ),
           if (showNavigationButtons)
          Text(
            '${currentAnswerIndex.value + 1}/${answers.length}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          if (showNavigationButtons)
            _buildIconButton(
              Icons.arrow_forward,
              Strings.next.tr,
              () => _changeAnswer(1),
              enabled: currentAnswerIndex.value < answers.length - 1,
            ),
          Obx(() => _buildIconButton(
                isSpeaking.value ? Icons.stop : Icons.volume_up,
                isSpeaking.value ? Strings.stop.tr : Strings.sound.tr,
                () => _toggleSpeech(context),
              )),
          _buildIconButton(Icons.copy, Strings.copy.tr, _copyToClipboard),
        ],
      ),
    );
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(
        ClipboardData(text: answers[currentAnswerIndex.value].content ?? ''));
    Get.snackbar(
      Strings.copied.tr,
      Strings.textHasBeenCopied.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }


  Widget _buildIconButton(IconData icon, String tooltip, VoidCallback onPressed,
      {bool enabled = true}) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        Color iconColor = enabled ? Colors.black : Colors.grey;
        Color backgroundColor =
            enabled ? Colors.transparent : Colors.grey.withOpacity(0.2);

        return MouseRegion(
          onEnter: enabled
              ? (_) {
                  setState(() {
                    iconColor = Colors.blue;
                    backgroundColor = Colors.blue.withOpacity(0.1);
                  });
                }
              : null,
          onExit: enabled
              ? (_) {
                  setState(() {
                    iconColor = Colors.grey;
                    backgroundColor = Colors.transparent;
                  });
                }
              : null,
          child: Tooltip(
            message: tooltip,
            child: GestureDetector(
              onTapDown: enabled
                  ? (_) {
                      setState(() {
                        backgroundColor = Colors.blue.withOpacity(0.2);
                      });
                    }
                  : null,
              onTapUp: enabled
                  ? (_) {
                      setState(() {
                        backgroundColor = Colors.blue.withOpacity(0.1);
                      });
                      onPressed();
                    }
                  : null,
              onTapCancel: enabled
                  ? () {
                      setState(() {
                        backgroundColor = Colors.transparent;
                      });
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 4, bottom: 4),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backgroundColor,
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(icon, color: iconColor, size: 15),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _changeAnswer(int direction) {
    int newIndex = currentAnswerIndex.value + direction;
    if (newIndex >= 0 && newIndex < answers.length) {
      currentAnswerIndex.value = newIndex;
    }
  }


  Future<void> _toggleSpeech(BuildContext context) async {
    if (isSpeaking.value) {
      await flutterTts.stop();
    } else {
      await flutterTts.speak(answers[currentAnswerIndex.value].content ?? '');
    }

    isSpeaking.value = !isSpeaking.value;
  }

   List<Widget> buildMediaWidgets(List<AnswerMedia> mediaList) {
    List<Widget> widgets = [];
    List<String> imageUrls = [];

    for (var media in mediaList) {
      if (media.mediaType == 'Audio') {
        widgets.add(AudioFileMessage(
          audioSrc: media.mediaUrl ?? '',
          maxDuration: const Duration(seconds: 60), 
        ));
        widgets.add(SizedBox(height: 8.h));
      } else if (media.mediaType == 'Image') {
        imageUrls.add(media.mediaUrl ?? '');
      }
    }

    if (imageUrls.isNotEmpty) {
      widgets.add(ImageGridBuilder.buildImageGrid(imageUrls));
    }

    return widgets;
  }
}
