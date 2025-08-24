import 'package:agri_ai/app/data/providers/app_setting_provider.dart';
import 'package:get/get.dart';
import 'package:agri_ai/app/routes/app_pages.dart';
import 'package:agri_ai/app/controllers/auth_controller.dart';

class SplashPageController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

   final AppSettingProvider appProvider = Get.find<AppSettingProvider>();
  @override
  Future<void> onReady() async {
    super.onReady();


 await appProvider.getAppSetting();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    if (await authController.isLogin()) {
      // Redirect based on user type
      final bool isAdmin  = await authController.isAdmin();
      final bool isExpert = await authController.isAgriculturalExpert();
      final bool isClient = await authController.isClient();

      if (isAdmin) {
        Get.offAllNamed(Routes.HOME); 
      } else if (isExpert) {
        Get.offAllNamed(Routes.HOME); 
      } else if (isClient) {
        Get.offAllNamed(Routes.HOME); 
      } else {
        Get.offAllNamed(Routes.HOME); 
      }
    } else {
      Get.offAllNamed(Routes.IntroductionAnimation);
    }
  }
}
