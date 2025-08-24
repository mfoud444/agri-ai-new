import 'package:agri_ai/app/modules/chat/views/widgets/messages_view.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/chat_drawer/chat_drawer.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/chat_drawer/drawer_chat_controller.dart';
import 'package:agri_ai/config/theme/app_theme.dart';

import 'package:flutter/material.dart';


class MainChatAiView extends StatefulWidget {
  const MainChatAiView({super.key});
  @override
  _MainChatAiViewState createState() => _MainChatAiViewState();
}

class _MainChatAiViewState extends State<MainChatAiView> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.ChatAiChatView;
    screenView =  MessagesView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerChatController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            // onDrawerCall: (DrawerIndex drawerIndexdata) {
            //   changeIndex(drawerIndexdata);
           
            // },
            screenView: screenView,
           
          ),
        ),
      ),
    );
  }

  // void changeIndex(DrawerIndex drawerIndexdata) {
  //   if (drawerIndex != drawerIndexdata) {
  //     drawerIndex = drawerIndexdata;
  //     switch (drawerIndex) {
  //       case DrawerIndex.ChatAiChatView:
  //     //    final CurrentConversationController currentConversationController =
  //     // Get.put(CurrentConversationController());
  //     //   currentConversationController.setCurrentConversation(drawerIndexdata.);
  //         break;

  //       default:
  //         break;
  //     }
  //   }
  // }
}



