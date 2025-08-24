import 'package:agri_ai/app/data/models/notification_item_model.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/list_notification_controller.dart';
class ListNotificationView extends GetView<ListNotificationController> {
  const ListNotificationView({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.notifications.tr),
        centerTitle: true,
      ),
      body: Obx(
        () => Skeletonizer(
          enabled: controller.isLoading.value,
          child: controller.notifications.isEmpty
              ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30.h),
            Container(
                    constraints: const BoxConstraints(maxWidth: 350, maxHeight: 250),
                    child: Image.asset(
                      'assets/images/no_notification.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                
                   Text(
                    Strings.noNotifications.tr,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ]))
              : ListView.builder(
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return NotificationTile(notification: notification);
                  },
                ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: notification.isRead ?? false ? Colors.grey : Colors.blue,
        child:
         Icon(
          _getIconData(notification.icon ?? ''),
          color: Colors.white,
        ),
      ),
      title: Text(
        notification.title ?? '',
        style: TextStyle(
          fontWeight: notification.isRead ?? false ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(notification.body ?? ''),
      // trailing: Text(
      //   _formatDate(notification.createdAt!),
      //   style: const TextStyle(fontSize: 12),
      // ),
      onTap: () {
        Get.find<ListNotificationController>().markAsRead(notification.id ?? '');
      },
    );
  }

  IconData _getIconData(String? icon) {
    switch (icon) {
      case 'message':
        return Icons.message;
      case 'update':
        return Icons.update;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${_getDayName(date.weekday)} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return Strings.mon.tr;
      case 2: return Strings.tue.tr;
      case 3: return Strings.wed.tr;
      case 4: return Strings.thu.tr;
      case 5: return Strings.fri.tr;
      case 6: return Strings.sat.tr;
      case 7: return Strings.sun.tr;
      default: return '';
    }
  }
}