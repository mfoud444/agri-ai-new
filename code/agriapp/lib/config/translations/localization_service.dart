import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/local/my_shared_pref.dart';
import 'ar_AR/ar_ar_translation.dart';
import 'en_US/en_us_translation.dart';

class LocalizationService extends Translations {
  // prevent creating instance
  LocalizationService._();

  static LocalizationService? _instance;

  static LocalizationService getInstance() {
    _instance ??= LocalizationService._();
    return _instance!;
  }

  // default language
  // todo change the default language
  static Locale defaultLanguage = supportedLanguages['en']!;

  // supported languages
  static Map<String,Locale> supportedLanguages = {
    'en' : const Locale('en', 'US'),
    'ar' : const Locale('ar', 'AR'),
  };

  // supported languages fonts family (must be in assets & pubspec yaml) or you can use google fonts
  static Map<String,TextStyle> supportedLanguagesFontsFamilies = {
    // todo add your English font families (add to assets/fonts, pubspec and name it here) default is poppins for english and cairo for arabic
    'en' : const TextStyle(fontFamily: 'Poppins'),
    'ar': const TextStyle(fontFamily: 'Amiri'),
  };

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUs,
    'ar_AR': arAR,
  };

  /// check if the language is supported
  static isLanguageSupported(String languageCode) =>
    supportedLanguages.keys.contains(languageCode);



  static updateLanguage(String languageCode) async {
 
    if(!isLanguageSupported(languageCode)) return;
    
    await MySharedPref.setCurrentLanguage(languageCode);
    if(!Get.testMode) {
      Get.updateLocale(supportedLanguages[languageCode]!);
    }
  }


  static bool isItEnglish() =>
      MySharedPref.getCurrentLocal().languageCode.toLowerCase().contains('en');

 
  static Locale getCurrentLocal () => MySharedPref.getCurrentLocal();
}

