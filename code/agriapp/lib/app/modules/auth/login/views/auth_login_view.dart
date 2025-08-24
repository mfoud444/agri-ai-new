import 'package:agri_ai/app/components/error_message.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:agri_ai/app/components/gradient_text.dart';
import 'package:agri_ai/app/components/gradient_underline_text.dart';
import '../controllers/auth_login_controller.dart';
import '../../../../controllers/auth_controller.dart';

class AuthLoginView extends GetView<AuthLoginController> {
  final authC = Get.find<AuthController>();

   AuthLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Center(
              //   child: Image.asset(
              //     'assets/images/login.png',
              //     height: 150.h,
              //   ),
              // ),
          
              Container(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 16,
                  bottom: 16,
                ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(text: Strings.welcome.tr),
                    GradientText(text: Strings.back.tr),
                  ],
                ),
              ),

             Obx(() => ErrorMessage(
                    message: controller.errorMessage.value,
                    isVisible: controller.errorMessage.isNotEmpty,
                  )),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                margin: const EdgeInsets.all(3),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        autocorrect: false,
                        controller: controller.emailC,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: Strings.email.tr,
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() => TextField(
                            autocorrect: false,
                            controller: controller.passwordC,
                            textInputAction: TextInputAction.done,
                            obscureText: controller.isHidden.value,
                            decoration: InputDecoration(
                              labelText: Strings.password.tr,
                              prefixIcon: const Icon(
                                Icons.lock,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => controller.isHidden.toggle(),
                                icon: Icon(
                                  controller.isHidden.isTrue
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 243, 33, 173),
                                    width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2),
                              ),
                            ),
                          )),
                      const SizedBox(height: 30),
                      Obx(() => ElevatedButton(
                            onPressed: controller.isLoading.value ? null :() async {
                              
                               
                              
                                  await controller.login();
                                  
                             
                             
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(38.0),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text(
                              controller.isLoading.isFalse
                                  ? Strings.login.tr
                                  : Strings.loading.tr,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Strings.dontHaveAccount.tr,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed('/signup'),
                            child: GradientUnderlineText(
                              text: Strings.signUp.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 10.h),
                      // const OrDivider(),
                      // SizedBox(height: 20.h),
                      // SocialMediaButtons(
                      //   onGooglePressed: () {
                      //     // Add Google login logic here
                      //   },
                      //   onFacebookPressed: () {
                      //     // Add Facebook login logic here
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
