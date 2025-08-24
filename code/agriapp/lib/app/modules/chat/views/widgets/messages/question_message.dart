import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:agri_ai/app/data/local/my_hive.dart';
import 'package:agri_ai/app/data/models/conversation_model.dart';
import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/messages/audio_file_message.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/messages/image_grid_builder.dart';
import 'package:agri_ai/app/data/models/user_model.dart' as local_user;
import 'package:intl/intl.dart';

class QuestionMessage extends GetView<ChatAiChatController> {
  final Question question;

  QuestionMessage({
    super.key,
    required this.question,
  });

  final FlutterTts flutterTts = FlutterTts();
  final RxBool isSpeaking = false.obs;

  @override
  Widget build(BuildContext context) {
    local_user.User? currentUser = MyHive.getCurrentUser();
    final avatarUser = currentUser?.avatarUrl != null
        ? "Q"
        : (currentUser?.firstName?.isNotEmpty ?? false
            ? currentUser!.firstName![0].toUpperCase()
            : 'Q');

 final createdAtString = question.createdAt ?? '';

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
      padding: EdgeInsets.all(8.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                backgroundImage: currentUser?.avatarUrl != null
                    ? NetworkImage(currentUser!.avatarUrl!)
                    : null,
                child: currentUser?.avatarUrl == null
                    ? Text(avatarUser, style: const TextStyle(color: Colors.white))
                    : null,
              ),
              SizedBox(width: 8.0.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.state.nameHeaderQuestion.value,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    SizedBox(height: 4.h),
                    Text(formattedDate,
                        style: TextStyle(color: Colors.grey, fontSize: 10.sp)),
                    SizedBox(height: 4.h),
                    Text(question.content ?? '',
                        style: TextStyle(fontSize: 15.sp)),
                    SizedBox(height: 4.h),
                    if (question.questionMedia != null &&
                        question.questionMedia!.isNotEmpty)
                      ...buildMediaWidgets(question.questionMedia!),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildIconRow(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => _buildIconButton(
              isSpeaking.value ? Icons.stop : Icons.volume_up,
              isSpeaking.value ? 'Stop' : 'Sound',
              () => _toggleSpeech(context),
            )),
        _buildIconButton(Icons.copy, 'Copy', _copyToClipboard),
      ],
    );
  }

  Future<void> _toggleSpeech(BuildContext context) async {
    if (isSpeaking.value) {
      await flutterTts.stop();
    } else {
      await flutterTts.speak(question.content ?? '');
    }
    isSpeaking.value = !isSpeaking.value;
  }


  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: question.content ?? ''));
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
                    left: 5.0, right: 5.0, top: 4, bottom: 0),
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

  List<Widget> buildMediaWidgets(List<QuestionMedia> mediaList) {
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
