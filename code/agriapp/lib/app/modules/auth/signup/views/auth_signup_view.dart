import 'package:agri_ai/app/components/error_message.dart';
import 'package:agri_ai/app/components/gradient_text.dart';
import 'package:agri_ai/app/components/gradient_underline_text.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../controllers/auth_signup_controller.dart';
class AuthSignupView extends GetView<AuthSignupController> {
  const AuthSignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0.h),
                  child: Row(
                    children: [
                      Obx(() => Visibility(
                        visible: controller.currentStep.value > 0,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: controller.currentStep.value > 0 ? controller.previousPage : null,
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),

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
                    GradientText(text: Strings.create.tr),
                    GradientText(text: Strings.account.tr),
                  ],
                ),
              ),

                 Obx(() => ErrorMessage(
                    message: controller.errorMessage.value,
                    isVisible: controller.errorMessage.isNotEmpty,
                     actionWidget: controller.actionWidget.value
                  )),
                 
                SizedBox(height: 20.h),
                
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 160.h, 
                  ),
                  child: PageView(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StepOne(controller: controller),
                      StepTwo(controller: controller),
                      StepThree(controller: controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StepOne extends StatelessWidget {
  final AuthSignupController controller;
  const StepOne({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.h),
      child: Column(
        children: [
          Obx(() => TextField(
            controller: controller.firstNameC,
            focusNode: controller.firstNameFocus,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: Strings.firstName.tr,
              prefixIcon: const Icon(Icons.person),
              errorText: controller.firstNameError.value.isEmpty ? null : controller.firstNameError.value,
            ),
          )),
          SizedBox(height: 16.h),
          Obx(() => TextField(
            controller: controller.lastNameC,
            focusNode: controller.lastNameFocus,
            decoration: InputDecoration(
              labelText: Strings.lastName.tr,
              prefixIcon: const Icon(Icons.person),
              errorText: controller.lastNameError.value.isEmpty ? null : controller.lastNameError.value,
            ),
          )),
          SizedBox(height: 20.h),
          Obx(() => ElevatedButton(
            onPressed: controller.canProceedStep1() ? controller.nextPage : null,
            child: Text(Strings.next.tr),
          )),

          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Strings.alreadyHaveAccount.tr,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed('/login'),
                child: GradientUnderlineText(
                  text: Strings.login.tr,
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
    );
  }
}

class StepTwo extends StatelessWidget {
  final AuthSignupController controller;
  const StepTwo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.h),
      child: Column(
        children: [
          TextField(
            controller: controller.countryC,
            decoration: InputDecoration(
              labelText: Strings.country.tr,
              prefixIcon: const Icon(Icons.public),
            ),
            readOnly: true,
            onTap: () {
              showCountryPicker(
                context: context,
                onSelect: (Country country) {
                  controller.countryC.text = country.name;
                },
              );
            },
          ),
          SizedBox(height: 16.h),
          Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: controller.showGenderDropdownMargin.value ? EdgeInsets.only(bottom: 20.h) : EdgeInsets.zero,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: Strings.gender.tr,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              value: controller.genderC.text.isEmpty ? 'Male' : controller.genderC.text,
              items: ['Male', 'Female', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                controller.genderC.text = newValue ?? '';
                controller.showGenderDropdownMargin.value = newValue != null && newValue.isNotEmpty;
              },
            ),
          )),
          SizedBox(height: 20.h),
         ElevatedButton(
            onPressed:  controller.nextPage ,
            child: Text(Strings.next.tr),
          ),
        ],
      ),
    );
  }
}

class StepThree extends StatelessWidget {
  final AuthSignupController controller;
  const StepThree({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.h),
      child: Column(
        children: [
          Obx(() => TextField(
            controller: controller.emailC,
            focusNode: controller.emailFocus,
            decoration: InputDecoration(
              labelText: Strings.email.tr,
              prefixIcon: const Icon(Icons.email),
              errorText: controller.emailError.value.isEmpty ? null : controller.emailError.value,
            ),
          )),
          SizedBox(height: 16.h),
          Obx(() => TextField(
            controller: controller.passwordC,
            focusNode: controller.passwordFocus,
            obscureText: controller.isHidden.value,
            decoration: InputDecoration(
              labelText: Strings.password.tr,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isHidden.value ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => controller.isHidden.toggle(),
              ),
              errorText: controller.passwordError.value.isEmpty ? null : controller.passwordError.value,
            ),
          )),
          SizedBox(height: 16.h),
          Obx(() => TextField(
            controller: controller.confirmPasswordC,
            focusNode: controller.confirmPasswordFocus,
            obscureText: controller.isHidden.value,
            decoration: InputDecoration(
              labelText: Strings.confirmPassword.tr,
              prefixIcon: const Icon(Icons.lock),
              errorText: controller.confirmPasswordError.value.isEmpty ? null : controller.confirmPasswordError.value,
            ),
          )),
          SizedBox(height: 20.h),
          Obx(() => ElevatedButton(
            onPressed: (controller.canProceedStep3() && !controller.isLoading.value) ? controller.signUp : null,
            child: Text(controller.isLoading.isFalse ? Strings.register.tr : Strings.loading.tr),
          )),
        ],
      ),
    );
  }
}
