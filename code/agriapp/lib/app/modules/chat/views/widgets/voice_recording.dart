import 'dart:async';
import 'package:flutter/material.dart';

class VoiceRecording extends StatefulWidget {
  final void Function() onCancel;
  final void Function() onPause;
  final void Function() onResume;
  final void Function() onConfirm;
  final bool isRecording;
  final bool isPaused;
  final bool isUserRegistered;

  const VoiceRecording({
    super.key,
    required this.onCancel,
    required this.onPause,
    required this.onResume,
    required this.onConfirm,
    required this.isRecording,
    required this.isPaused,
    required this.isUserRegistered,
  });

  @override
  _VoiceRecordingState createState() => _VoiceRecordingState();
}

class _VoiceRecordingState extends State<VoiceRecording> {
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isRecording) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant VoiceRecording oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _startTimer();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _stopTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${_twoDigits(minutes)}:${_twoDigits(remainingSeconds)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  _formatTime(_seconds),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: LinearProgressIndicator(
                    value: widget.isRecording ? null : 0.0,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: widget.onCancel,
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: widget.isPaused ? widget.onResume : widget.onPause,
                  child: CircleAvatar(
                    backgroundColor: widget.isPaused ? Colors.green : Colors.orange,
                    child: Icon(
                      widget.isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: widget.isUserRegistered ? widget.onConfirm : null,
                  child: CircleAvatar(
                    backgroundColor: widget.isUserRegistered ? Colors.blue : Colors.grey,
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
