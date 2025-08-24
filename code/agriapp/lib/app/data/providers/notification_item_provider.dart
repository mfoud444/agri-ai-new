import 'package:get/get.dart';

import '../models/notification_item_model.dart';

class NotificationItemProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return NotificationItem.fromJson(map);
      if (map is List) {
        return map.map((item) => NotificationItem.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<NotificationItem?> getNotificationItem(int id) async {
    final response = await get('notificationitem/$id');
    return response.body;
  }

  Future<Response<NotificationItem>> postNotificationItem(
          NotificationItem notificationitem) async =>
      await post('notificationitem', notificationitem);
  Future<Response> deleteNotificationItem(int id) async =>
      await delete('notificationitem/$id');
}
