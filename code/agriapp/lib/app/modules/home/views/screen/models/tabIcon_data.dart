import 'package:agri_ai/app/controllers/auth_controller.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TabIconData {
  TabIconData({
    this.icon,
    this.selectedIcon,
    this.imagePath,
    this.imageSelectedPath,
    required this.label,
    this.index = 0,
    this.isSelected = false,
    this.animationController,
  });

   IconData? icon;
   IconData? selectedIcon;
   String? imagePath; // Path for the default image
   String? imageSelectedPath; // Path for the selected image
   String label;
   bool isSelected;
   int index;
   AnimationController? animationController;
  final AuthController authController = Get.find<AuthController>();
  // if (Get.find<AuthController>().isUserClient())
  static List<TabIconData> tabIconsList = [
    TabIconData(
       imagePath: 'assets/images/home.png',
      imageSelectedPath: 'assets/images/home.png',
      label: Strings.home.tr,
      index: 0,
      isSelected: true,
    ),
    
    TabIconData(
      imagePath: 'assets/images/chat_ai_icon.png',
      imageSelectedPath: 'assets/images/chat_ai_icon.png', 
      label: Strings.chatAI.tr,
      index: 1,
      isSelected: false,
    ),
    TabIconData(
      
         imagePath: 'assets/images/gardener.png',
      imageSelectedPath: 'assets/images/gardener.png', 
   
      label: Strings.chat.tr,
      index: 2,
      isSelected: false,
    ),
    TabIconData(
        imagePath: 'assets/images/option.png',
      imageSelectedPath: 'assets/images/option.png', 
      label: Strings.more.tr,
      index: 3,
      isSelected: false,
    ),
  ];
}

