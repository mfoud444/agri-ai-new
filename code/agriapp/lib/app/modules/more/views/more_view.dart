// more_view.dart
import 'package:agri_ai/app/controllers/auth_controller.dart';
import 'package:agri_ai/app/data/local/my_hive.dart';
import 'package:agri_ai/app/data/models/user_model.dart' as local_user;
import 'package:agri_ai/app/modules/more/views/widgets/menu_item_widget.dart';
import 'package:agri_ai/app/routes/app_pages.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/more_controller.dart';
// more_view.dart

class MoreView extends GetView<MoreController> {
  final AuthController authController = Get.find<AuthController>();

   MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final MoreController controller = Get.put(MoreController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              const UserProfileWidget(),
              SizedBox(height: 20.h),
              MenuItemWidget(
                icon: Icons.person,
                title: Strings.profile.tr,
                onTap: () {
                  Get.toNamed(Routes.PROFILE);
                },
              ),
              MenuItemWidget(
                icon: Icons.settings,
                title: Strings.settings.tr,
                onTap: () {
                  Get.toNamed(Routes.SETTINGS);
                },
              ),
              MenuItemWidget(
                icon: Icons.star,
                title: Strings.rateOurApp.tr,
                onTap: controller.rateApp,
              ),
              MenuItemWidget(
                icon: Icons.share,
                title: Strings.shareTheApp.tr,
                onTap: controller.shareApp,
              ),
              MenuItemWidget(
                icon: Icons.logout,
                title: Strings.logout.tr,
                onTap: () async {
                  await authController.logout();
                },
                textColor: Colors.red,
                iconColor: Colors.red,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}


class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final local_user.User? currentUser = MyHive.getCurrentUser();

    return Column(
      children: [
        SizedBox(height: 20.h),
        CircleAvatar(
          radius: 50.r,
          backgroundColor: Colors.grey[300],
          backgroundImage: currentUser?.avatarUrl != null && currentUser!.avatarUrl!.isNotEmpty
              ? NetworkImage(currentUser.avatarUrl!)
              : null,
          child: currentUser?.avatarUrl == null || currentUser!.avatarUrl!.isEmpty
              ? Icon(Icons.person, size: 50.r, color: Colors.grey[600])
              : null,
        ),
        SizedBox(height: 10.h),
        Text(
          '${currentUser?.firstName ?? ''} ${currentUser?.lastName ?? ''}',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}