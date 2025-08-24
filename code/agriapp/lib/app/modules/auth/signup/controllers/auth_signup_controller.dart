import 'package:agri_ai/app/components/gradient_underline_text.dart';
import 'package:agri_ai/app/data/local/my_shared_pref.dart';
import 'package:agri_ai/app/data/models/user_model.dart' as local_user;
import 'package:agri_ai/app/data/local/my_hive.dart';
import 'package:agri_ai/app/data/providers/app_setting_provider.dart';
import 'package:agri_ai/app/routes/app_pages.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:agri_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class AuthSignupController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  RxBool showGenderDropdownMargin = false.obs;

  RxString errorMessage = ''.obs; 
  PageController pageController = PageController();
  RxInt currentStep = 0.obs;

  TextEditingController firstNameC = TextEditingController();
  TextEditingController lastNameC = TextEditingController();
  TextEditingController countryC = TextEditingController();
  TextEditingController genderC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  RxString firstNameError = ''.obs;
  RxString lastNameError = ''.obs;
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;
  RxString confirmPasswordError = ''.obs;

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  RxBool canProceedStep1 = false.obs;
  RxBool canProceedStep2 = true.obs;
  RxBool canProceedStep3 = false.obs; 
   var actionWidget = Rxn<Widget>();
 final AppSettingProvider appProvider = Get.find<AppSettingProvider>();
  @override
  void onInit() {
    super.onInit();
    firstNameFocus.addListener(() {
      if (!firstNameFocus.hasFocus) validateFirstName();
    });
    lastNameFocus.addListener(() {
      if (!lastNameFocus.hasFocus) validateLastName();
    });
    emailFocus.addListener(() {
      if (!emailFocus.hasFocus) validateEmail();
    });
    passwordFocus.addListener(() {
      if (!passwordFocus.hasFocus) validatePassword();
    });
   confirmPasswordC.addListener(validateConfirmPassword);


    // Add listeners for text changes
    firstNameC.addListener(validateFirstName);
    lastNameC.addListener(validateLastName);
    emailC.addListener(validateEmail);
    passwordC.addListener(validatePassword);
    confirmPasswordC.addListener(validateConfirmPassword);

    
  }

  void validateFirstName() {
    if (firstNameC.text.isEmpty) {
      firstNameError.value = Strings.firstNameEmpty.tr;
    } else {
      firstNameError.value = '';
    }
    validateCanProceedStep1();
  }

  void validateLastName() {
    if (lastNameC.text.isEmpty) {
      lastNameError.value = Strings.lastNameEmpty.tr;
    } else {
      lastNameError.value = '';
    }
    validateCanProceedStep1();
  }

  void validateEmail() {
    if (!GetUtils.isEmail(emailC.text)) {
      emailError.value = Strings.invalidEmailFormat.tr;
    } else {
      emailError.value = '';
    }
      validateCanProceedStep3();
  }

  void validatePassword() {
    if (passwordC.text.length < 8) {
      passwordError.value = Strings.passwordTooShort.tr;
    } else {
      passwordError.value = '';
    }
      validateCanProceedStep3();
  }

  void validateConfirmPassword() {
    if (passwordC.text != confirmPasswordC.text) {
      confirmPasswordError.value = Strings.passwordsDoNotMatch.tr;
    } else {
      confirmPasswordError.value = '';
    }
      validateCanProceedStep3();
  }


  void validateCanProceedStep1() {
    canProceedStep1.value = firstNameC.text.isNotEmpty && lastNameC.text.isNotEmpty;
  }

   void validateCanProceedStep3() {
    canProceedStep3.value = emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty &&
        emailC.text.isNotEmpty &&
        passwordC.text.isNotEmpty &&
        confirmPasswordC.text.isNotEmpty;
  }

bool canProceed() {
  if (currentStep.value == 0) {
    return firstNameC.text.isNotEmpty && lastNameC.text.isNotEmpty;
  } else if (currentStep.value == 1) {
    return genderC.text.isNotEmpty;
  }
  return true;
}

  bool canSubmit() {
    return emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty &&
        !isLoading.value;
  }

  Future<void> nextPage() async {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
       await Future.delayed(const Duration(milliseconds: 50));
    if (currentStep.value < 2) {
      currentStep.value++;
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void previousPage() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

 Future<void> signUp() async {
    if (canSubmit()) {
      isLoading.value = true;
 errorMessage.value = ''; 
      // Set default values for gender and country if they are not set
      final gender = genderC.text.isEmpty ? 'Male' : genderC.text;
      final country = countryC.text.isEmpty ? '' : countryC.text;

      try {
        var token = MySharedPref.getFcmToken();
        AuthResponse res = await supabase.auth.signUp(
          email: emailC.text,
          password: passwordC.text,
          data: {
            'first_name': firstNameC.text,
            'last_name': lastNameC.text,
             'email': emailC.text,
            'avatar_url': '',
            'state': true,
            'gender': gender,
            'user_type': 'Client',
            'country': country,
            'fcm_token':token
          },
        );

        isLoading.value = false;

        // Create a User object from the response data
        local_user.User newUser = local_user.User(
          id: res.user!.id,
          firstName: firstNameC.text,
          lastName: lastNameC.text,
          email: emailC.text,
          gender: gender,
          userType: 'Client',
          country: country,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );

        // Save the user to Hive
        bool saved = await MyHive.saveUserToHive(newUser);

        if (saved) {
           await appProvider.checkAndFetchClientConversation();
         
           Get.offAllNamed(Routes.HOME);
        } else {
           errorMessage.value = Strings.failedToSaveUser.tr;
     
        }
      } on AuthException catch (e) {
      isLoading.value = false;

 if (e.statusCode == '422') {
        errorMessage.value = Strings.emailAlreadyRegistered.tr;
        // Add the GestureDetector widget for navigating to the login page
        actionWidget.value = GestureDetector(
          onTap: () => Get.toNamed('/login'),
          child: GradientUnderlineText(
            text: Strings.login.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[400]
            ),
          ),
        );
      } else {
        errorMessage.value = '${Strings.registrationFailed.tr}\n${e.message}';
      }
  
    } catch (e) {
        isLoading.value = false;
        errorMessage.value = Strings.registrationFailed.tr + e.toString();
       
      }
    } else {
      errorMessage.value = Strings.pleaseFillFields.tr;
      
    }
  }
}
