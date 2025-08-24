import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SocialMediaButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;

  const SocialMediaButtons({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.g_mobiledata, color: Colors.red),
            label: Text("Google".tr),
            onPressed: onGooglePressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                const Color.fromARGB(255, 231, 218, 218),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.facebook, color: Colors.white),
            label: Text(
              "Facebook".tr,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
            onPressed: onFacebookPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue[800]),
            ),
          ),
        ),
      ],
    );
  }
}
