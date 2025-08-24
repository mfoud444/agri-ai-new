import 'package:flutter/material.dart';

class SoundWaveformWidget extends StatefulWidget {
  final int count;
  final double minHeight;
  final double maxHeight;
  final int durationInMilliseconds;

  const SoundWaveformWidget({
    super.key,
    this.count = 6,
    this.minHeight = 10,
    this.maxHeight = 30,
    this.durationInMilliseconds = 3000,
  });

  @override
  State<SoundWaveformWidget> createState() => _SoundWaveformWidgetState();
}

class _SoundWaveformWidgetState extends State<SoundWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: widget.durationInMilliseconds,
        ))
      ..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.count;
    final minHeight = widget.minHeight;
    final maxHeight = widget.maxHeight;
    return AnimatedBuilder(
      animation: controller,
      builder: (c, child) {
        double t = controller.value;
        int current = (count * t).floor();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            count,
            (i) => AnimatedContainer(
              duration: Duration(
                  milliseconds: widget.durationInMilliseconds ~/ count),
              margin: i == (count - 1)
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(right: 5),
              height: i == current ? maxHeight : minHeight,
              width: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
        );
      },
    );
  }
}