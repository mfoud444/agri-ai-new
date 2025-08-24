import 'dart:io' as io;
import 'package:agri_ai/app/data/models/app_setting_model.dart';
import 'package:agri_ai/app/data/providers/app_setting_provider.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreController extends GetxController {
   final AppSettingProvider appSettingProvider = Get.find();
  Rx<AppSetting?> appSetting = Rx<AppSetting?>(null);

  @override
  void onInit() {
    super.onInit();
    // Initialize appSettingProvider
    // appSettingProvider = Get.find<AppSettingProvider>();

    // Initialize appSetting using the provider
    appSetting = appSettingProvider.appSetting;
  }

  void shareApp() {
    Share.share('Check out this amazing app: [App Link]');
  }

  void rateApp() async {
    final url = _getAppStoreUrl();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle URL launch failure
      Get.snackbar('Error', 'Could not launch URL');
    }
  }

  String _getAppStoreUrl() {
    final appSettingValue = appSetting.value;

    if (appSettingValue == null) {
      // Handle the case where appSetting is null
      return '';
    }

    // Check platform and return the appropriate URL
    if (io.Platform.isAndroid) {
      return appSettingValue.urlGooglplay ?? 'https://play.google.com/store/apps/details?id=com.example.app'; 
    } else if (io.Platform.isIOS) {
      return appSettingValue.urlAppstore ?? 'https://apps.apple.com/us/app/id1234567890'; 
    } else {
      // Handle other platforms or provide a fallback URL
      return '';
    }
  }
}
