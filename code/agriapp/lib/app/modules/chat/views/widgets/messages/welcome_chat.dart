// welcome_widget.dart
import 'package:agri_ai/app/components/gradient_text.dart';
import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// welcome_widget.dart

class WelcomeChat extends GetView<ChatAiChatController> {
  const WelcomeChat({super.key});

  @override
  Widget build(BuildContext context) {
    final isAgriExpert = controller.state.isCurrentAgriConv();

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isAgriExpert ? 'assets/images/app_icon.png' : 'assets/images/logo_ai_chat.png',
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10.h),
            GradientText(
              text: isAgriExpert ? Strings.agriculturalExpert.tr : Strings.welcome.tr,
            ),
            SizedBox(height: 10.h),
            Text(
              isAgriExpert
                  ? Strings.agriExpertDescription.tr
                  : Strings.generalDescription.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
