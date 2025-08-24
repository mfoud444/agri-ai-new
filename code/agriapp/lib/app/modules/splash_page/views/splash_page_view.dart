import 'package:agri_ai/app/components/gradient_text.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_page_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPageView extends GetView<SplashPageController> {
  const SplashPageView({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690), minTextAdapt: true);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30.h),
            Container(
                    constraints: const BoxConstraints(maxWidth: 350, maxHeight: 250),
                    child: Image.asset(
                      'assets/images/splach.png',
                      fit: BoxFit.contain,
                    ),
                  ),
            Container(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientText(text: Strings.agricultural.tr),
                  GradientText(text: Strings.expert.tr),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Text(
            //   Strings.companionText.tr,
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 18.sp),
            // ),
            // SizedBox(height: 20.h),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
