import 'package:get/get.dart';

import '../controllers/list_notification_controller.dart';

class ListNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListNotificationController>(
      () => ListNotificationController(),
    );
  }
}
