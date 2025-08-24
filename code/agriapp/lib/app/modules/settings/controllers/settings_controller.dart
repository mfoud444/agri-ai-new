// lib/app/modules/settings/controllers/settings_controller.dart

import 'dart:ui';

import 'package:get/get.dart';
import 'package:agri_ai/config/translations/localization_service.dart';

class SettingsController extends GetxController {
  var isCustomThemeEnabled = true.obs;
  var selectedLanguage = LocalizationService.getCurrentLocal().obs;

  void toggleCustomTheme(bool value) {
    isCustomThemeEnabled.value = value;
  }

  void updateLanguage(Locale newLocale) {
    selectedLanguage.value = newLocale;
    LocalizationService.updateLanguage(newLocale.languageCode);
  }
}
