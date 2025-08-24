import 'package:agri_ai/app/data/local/my_hive.dart';

import 'package:agri_ai/app/data/providers/app_setting_provider.dart';
import 'package:agri_ai/app/data/providers/user_provider.dart';
import 'package:agri_ai/app/routes/app_pages.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agri_ai/app/data/models/user_model.dart' as local_user;
class AuthLoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  RxString errorMessage = ''.obs; 
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  SupabaseClient client = Supabase.instance.client;
 final AppSettingProvider appProvider = Get.find<AppSettingProvider>();
  Future<bool?> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      errorMessage.value = ''; 
      try {
        final AuthResponse res = await client.auth
            .signInWithPassword(email: emailC.text, password: passwordC.text);
     
        local_user.User newUser = local_user.User(
          id: res.user!.id,
          firstName: res.user?.userMetadata?['first_name'] ?? '',
          lastName: res.user?.userMetadata?['last_name'] ?? '',
          email: res.user?.userMetadata?['email'] ?? '',
          gender: res.user?.userMetadata?['gender'] ?? '',
          userType: res.user?.userMetadata?['user_type'] ?? 'Client',
          country: res.user?.userMetadata?['country'] ?? '',
          createdAt: res.user?.userMetadata?['created_at'] ?? DateTime.now().toString(),
          updatedAt: res.user?.userMetadata?['updated_at'] ?? DateTime.now().toString(),
        );

        bool saved = await MyHive.saveUserToHive(newUser);
        if (saved) {
          
          await appProvider.checkAndFetchClientConversation();
        await  Get.put<UserProvider>(UserProvider()).updateFcmToken();
          Get.offAllNamed(Routes.HOME);
        } else {
          errorMessage.value = Strings.failedToSaveUser.tr;
        }
        isLoading.value = false;

        return true;
      } catch (e) {
        isLoading.value = false;
        errorMessage.value = e.toString();
      }
    } else {
      errorMessage.value = Strings.emailPasswordRequired.tr;
    }
    return null;
  }
}
