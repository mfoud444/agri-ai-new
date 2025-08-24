import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/introduction_controller.dart';
import 'introduction_screen.dart';
class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({super.key});

  @override
  Widget build(BuildContext context) {
    return const IntroductionScreen();
  }
}
