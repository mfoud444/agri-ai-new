
import 'package:agri_ai/app/controllers/auth_controller.dart';
import 'package:agri_ai/app/data/models/notification_item_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListNotificationController extends GetxController {
  final notifications = <NotificationItem>[].obs;
  final isLoading = true.obs;


  @override
  Future<void> onReady() async {
    super.onReady();
    await fetchNotifications();
  }

    Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await Supabase.instance.client
          .from('notifications')
          .select('*')
          .eq('user_id', Get.find<AuthController>().getCurrentUserId())
          .order('created_at', ascending: false);

  
        final fetchedNotifications = List<Map<String, dynamic>>.from(response);
        notifications.value = fetchedNotifications
            .map((data) => NotificationItem.fromJson(data))
            .toList();
    
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Future<void> fetchNotifications() async {
  //   isLoading.value = true;
  //   await Future.delayed(const Duration(seconds: 2)); // Simulating API call
  //   notifications.value = [
  //     NotificationItem(id: '1', title: 'New message', icon: 'message', text: 'You have a new message', createdAt: '2024-08-13 10:00', isRead: false),
  //     NotificationItem(id: '2', title: 'System update', icon: 'update', text: 'System update is available', createdAt: '2024-08-13 09:30', isRead: true),
  //     // Add more sample notifications here
  //   ];
  //   isLoading.value = false;
  // }

  void markAsRead(String id) {
    final index = notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      final updatedNotification = notifications[index];
      updatedNotification.isRead = true;
      notifications[index] = updatedNotification;
    }
  }
}
