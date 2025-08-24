import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

class AudioFileMessage extends StatelessWidget {
  final String audioSrc;
  final Duration maxDuration;


  const AudioFileMessage({
    super.key,
    required this.audioSrc,
    this.maxDuration = const Duration(seconds: 30),

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          VoiceMessageView(
            controller: VoiceController(
              audioSrc: audioSrc,
              maxDuration: maxDuration,
              isFile: true,
              onComplete: () {
                      print("Audio playback completed.");
                    },
                    onPause: () {
                      print("Audio paused.");
                    },
                    onPlaying: () {
                      print("Audio is playing.");
                    },
                    onError: (err) {
                      print("Error playing audio: $err");
                    },
                  ),
         
            innerPadding: 12,
            cornerRadius: 20,
          ),
          const SizedBox(height: 8), 
        ],
      ),
    );
  }
}
