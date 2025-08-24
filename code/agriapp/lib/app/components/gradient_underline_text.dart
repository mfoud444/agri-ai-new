import 'package:flutter/material.dart';

class GradientUnderlineText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final double underlineHeight;

  const GradientUnderlineText({
    super.key,
    required this.text,
    this.style,
    this.gradient = const LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    this.underlineHeight = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: style,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: underlineHeight,
            decoration: BoxDecoration(
              gradient: gradient,
            ),
          ),
        ),
      ],
    );
  }
}