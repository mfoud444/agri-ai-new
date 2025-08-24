import 'dart:io';
import 'package:agri_ai/app/data/local/my_hive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';
import 'package:agri_ai/app/data/models/user_model.dart' as local_user;


import 'package:country_picker/country_picker.dart';

class ProfileController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;

  RxBool isLoading = false.obs;
  Rx<local_user.User> user = local_user.User().obs;

  // Text Editing Controllers
  TextEditingController firstNameC = TextEditingController();
  TextEditingController lastNameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController dateOfBirthC = TextEditingController();
  TextEditingController genderC = TextEditingController();
  TextEditingController countryC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  // Country code
  String selectedCountryCode = '';

  // Error messages
  RxString firstNameError = ''.obs;
  RxString lastNameError = ''.obs;
  RxString emailError = ''.obs;
  RxString dateOfBirthError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    isLoading.value = true;
    try {
      local_user.User? currentUser = MyHive.getCurrentUser();

      if (currentUser != null) {
        user.value = currentUser;
        _updateControllers();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void _updateControllers() {
    firstNameC.text = user.value.firstName ?? '';
    lastNameC.text = user.value.lastName ?? '';
    emailC.text = user.value.id ?? '';
    dateOfBirthC.text = user.value.dateOfBirth ?? '';
    genderC.text = user.value.gender ?? '';
    
    // Retrieve and set the country name using the country code
    selectedCountryCode = user.value.country ?? '';
    countryC.text = _getCountryNameFromCode(selectedCountryCode) ?? user.value.country ?? '';
  }

  String? _getCountryNameFromCode(String countryCode) {
    // Use country_picker to get country name from code
    final country = Country.tryParse(countryCode);
    return country?.name; // Return the country name
  }

  Future<void> updateProfile() async {
    if (_validateInputs()) {
      isLoading.value = true;
      try {
        final updates = <String, dynamic>{};

        // Add only non-empty fields to the updates map
        if (firstNameC.text.isNotEmpty) updates['first_name'] = firstNameC.text;
        if (lastNameC.text.isNotEmpty) updates['last_name'] = lastNameC.text;
        if (dateOfBirthC.text.isNotEmpty) updates['date_of_birth'] = dateOfBirthC.text;
        if (genderC.text.isNotEmpty) updates['gender'] = genderC.text;
        if (selectedCountryCode.isNotEmpty) updates['country'] = selectedCountryCode;

        if (updates.isNotEmpty) {
          // Update Supabase
          await client.from("users").update(updates).eq("id", user.value.id!);

          // Update local user object
          user.update((val) {
            if (firstNameC.text.isNotEmpty) val?.firstName = firstNameC.text;
            if (lastNameC.text.isNotEmpty) val?.lastName = lastNameC.text;
            if (dateOfBirthC.text.isNotEmpty) val?.dateOfBirth = dateOfBirthC.text;
            if (genderC.text.isNotEmpty) val?.gender = genderC.text;
            if (selectedCountryCode.isNotEmpty) val?.country = selectedCountryCode;
          });

          // Save updated user data to Hive
          final success = await MyHive.saveUserToHive(user.value);
          if (success) {
            Get.snackbar("Success", "Profile updated successfully");
          } else {
            Get.snackbar("Warning", "Profile updated but failed to save locally");
          }
        } else {
          Get.snackbar("Info", "No changes to update");
        }

        // Update password if provided
        if (passwordC.text.isNotEmpty) {
          await _updatePassword();
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to update profile: ${e.toString()}");
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> _updatePassword() async {
    try {
      await client.auth.updateUser(UserAttributes(
        password: passwordC.text,
      ));
      Get.snackbar("Success", "Password updated successfully");
      passwordC.clear();
    } catch (e) {
      Get.snackbar("Error", "Failed to update password: ${e.toString()}");
    }
  }
  Future<void> updateProfileImage(String imagePath) async {
    isLoading.value = true;
    try {
      final fileName = 'avatar_${user.value.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await client.storage.from('avatars').upload(fileName, File(imagePath));
      final publicUrl = client.storage.from('avatars').getPublicUrl(fileName);

      await client.from("users").update({
        "avatar_url": publicUrl,
      }).eq("id", user.value.id!);

      user.update((val) {
        val?.avatarUrl = publicUrl;
      });

      // Save updated user data to Hive
      await MyHive.saveUserToHive(user.value);

      Get.snackbar("Success", "Profile image updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile image: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    bool isValid = true;

    if (firstNameC.text.isEmpty) {
      firstNameError.value = "First name is required";
      isValid = false;
    } else {
      firstNameError.value = "";
    }

    if (lastNameC.text.isEmpty) {
      lastNameError.value = "Last name is required";
      isValid = false;
    } else {
      lastNameError.value = "";
    }

    return isValid;
  }

  Future<void> logout() async {
    await client.auth.signOut();
    await MyHive.deleteCurrentUser();
    Get.offAllNamed(Routes.AUTH_LOGIN);
  }
}
