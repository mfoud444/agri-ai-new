import 'package:get/get.dart';
import 'package:agri_ai/app/routes/app_pages.dart';

class ErrorLaunchController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> handleError() async {
    isLoading.value = true;

    try {
     
Get.offAllNamed(Routes.SPLASH_PAGE);
 
    } catch (error) {
      // Handle any errors during the retry process
      Get.snackbar('Error', 'Failed to restart the app $error');
    } finally {
      isLoading.value = false;
    }
  }
}
