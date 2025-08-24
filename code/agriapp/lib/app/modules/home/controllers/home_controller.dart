import 'package:agri_ai/app/modules/chat/views/screens/chat_view.dart';
import 'package:agri_ai/app/modules/home/views/screen/home_screen.dart';
import 'package:agri_ai/app/modules/more/views/more_view.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';
import 'package:agri_ai/app/modules/home/views/screen/models/tabIcon_data.dart';

class HomeController extends GetxController {
  final chatAiChatController = Get.put(ChatAiChatController());
  late AnimationController animationController;
 
  
  var tabIconsList = <TabIconData>[].obs;
  var selectedTabIndex = 0.obs;
  Rx<Widget> tabBody = Rx<Widget>(const SizedBox());

  @override
  void onInit() {
    super.onInit();

    updateTabIconsList();
    setTabBody(selectedTabIndex.value);
  }

  void updateTabIconsList() {
    chatAiChatController.state.updateUserType();
    if (chatAiChatController.state.isUserAgri.value) {
      tabIconsList.value = [
        TabIconData(
          imagePath: 'assets/images/gardener.png',
          imageSelectedPath: 'assets/images/gardener.png',
          label: 'Chat',
          index: 2,
          isSelected: false,
        ),
        TabIconData(
          imagePath: 'assets/images/option.png',
          imageSelectedPath: 'assets/images/option.png',
          label: 'More',
          index: 3,
          isSelected: false,
        ),
      ];
    } else {
      tabIconsList.value = [
        TabIconData(
          imagePath: 'assets/images/home.png',
          imageSelectedPath: 'assets/images/home.png',
          label: 'Home',
          index: 0,
          isSelected: true,
        ),
        TabIconData(
          imagePath: 'assets/images/chat_ai_icon.png',
          imageSelectedPath: 'assets/images/chat_ai_icon.png',
          label: 'Chat AI',
          index: 1,
          isSelected: false,
        ),
        TabIconData(
          imagePath: 'assets/images/gardener.png',
          imageSelectedPath: 'assets/images/gardener.png',
          label: 'Chat',
          index: 2,
          isSelected: false,
        ),
        TabIconData(
          imagePath: 'assets/images/option.png',
          imageSelectedPath: 'assets/images/option.png',
          label: 'More',
          index: 3,
          isSelected: false,
        ),
      ];
    }
  }

  void updateSelectedTabIndex(int index) {
    selectedTabIndex.value = index;
  }

  void setTabBody(int index) {
    switch (index) {
      case 1:
        chatAiChatController.initializeAISetup();
        tabBody.value = const ChatView();
        break;
      case 2:
        chatAiChatController.initializeAgriSetup();
        tabBody.value = const ChatView();
        break;
      case 3:
        tabBody.value =  MoreView();
        break;
      // case 0:
      // default:
      //  animationController = AnimationController(
      //   duration: const Duration(milliseconds: 200), vsync: this);

      //   tabBody.value = MyDiaryScreen(animationController:animationController);
      //   break;
    }
  }
}
