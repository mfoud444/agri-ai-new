import 'package:get/get.dart';

import '../controllers/error_launch_controller.dart';

class ErrorLaunchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ErrorLaunchController>(
      () => ErrorLaunchController(),
    );
  }
}
