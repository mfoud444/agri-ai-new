import 'dart:io';

import 'package:agri_ai/app/modules/chat/views/widgets/sound_waveform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/chat_ai_chat_controller.dart';
import 'image_preview.dart';

class CustomInputField extends GetView<ChatAiChatController> {
  final String hintText;

  const CustomInputField({
    super.key,
    required this.hintText,
    required Function(String value) onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (controller.state.isRecording.value) {
            return SocialMediaRecorder(
              startRecording: () {},
              stopRecording: (time) {},
              sendRequestFunction: (soundFile, time) {
                controller.state.selectedMediaFiles.add(soundFile);
              },
              encode: AudioEncoderType.AAC,
            );
          } else {
            return Column(
              children: [
                if (controller.state.selectedMediaFiles.isNotEmpty)
                  Obx(() {
                    return Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(
                        controller.state.selectedMediaFiles.length,
                        (index) => ImagePreview(
                          imagePath: controller.state.selectedMediaFiles[index].path,
                          onRemove: () => controller.removeSelectedMedia(index),
                          progress: controller.state.mediaUploadProgress[index],
                        ),
                      ),
                    );
                  }),
                if (controller.state.isListening.value)
                  Container(
                    height: 40.0,
                    padding: const EdgeInsets.all(5.0),
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const SoundWaveformWidget(),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.state.textController,
                              decoration: InputDecoration(
                                hintText: hintText,
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                fillColor: Colors.transparent,
                                filled: false,
                              ),
                              maxLines: 4,
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(() =>
                              _buildIconButton(
                                icon: controller.state.isListening.value ? Icons.stop : Icons.mic,
                                color: controller.state.isListening.value ? Colors.red : Colors.green,
                                onPressed: controller.state.toggleListening,
                              ),
                          ),
                          const SizedBox(width: 4),
                          Obx(() => Visibility(
                            visible: controller.state.isImageAllow(),
                            child: _buildIconButton(
                              icon: Icons.camera_alt,
                              color: Colors.green,
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                                if (image != null) {
                                  controller.state.selectedMediaFiles.add(File(image.path));
                                  controller.state.mediaUploadProgress.add(0.0);
                                  controller.service.simulateMediaUpload(controller.state);
                                }
                              },
                            ),
                          )),
                          const SizedBox(width: 4),
                          Obx(() => Visibility(
                            visible: controller.state.isImageAllow(),
                            child: _buildIconButton(
                              icon: Icons.attach_file,
                              color: Colors.green,
                              onPressed: controller.pickMultipleMedia,
                            ),
                          )),
                          const SizedBox(width: 4),
                          Obx(() => controller.state.isLoadingAnswerAI.value
                              ? _buildIconButton(
                            icon: Icons.stop,
                            color: Colors.red, 
                            onPressed: () {
                              controller.stopAIResponse();
                            },
                          )
                              : _buildIconButton(
                            icon: Icons.send,
                            color: controller.state.isNotEnableButtonSend() ? Colors.grey[400]! : Colors.green,
                            onPressed: controller.state.isNotEnableButtonSend()
                                ? null
                                : () {
                              controller.submitQuestion(controller.state.textController.text);
                            },
                          ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        }),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 30,
      height: 30,
      child: CircleAvatar(
        backgroundColor: color,
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
          splashRadius: 20,
          padding: EdgeInsets.zero,
          iconSize: 18,
        ),
      ),
    );
  }
}
