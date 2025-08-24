import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';
import 'package:agri_ai/config/theme/app_theme.dart';

class ChatDrawer extends StatefulWidget {
  const ChatDrawer({
    super.key,
    this.screenIndex,
    this.iconAnimationController,
    this.callBackIndex,
  });

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  @override
  _ChatDrawerState createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  final ChatAiChatController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    List<DrawerList>? drawerList = controller.state.drawerList;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                bool isButtonDisabled = controller.state.isDefaultConversation() ||
                    controller.state.isLoadingAnswerAI.value;

                return ElevatedButton.icon(
                  onPressed: isButtonDisabled
                      ? null
                      : () {
                          // Create a new conversation
                          controller.addNewConversation(Strings.newChat.tr);
                          if (drawerList.isNotEmpty) {
                            navigationtoScreen(drawerList[0].index!);
                          }
                        },
                  icon: const Icon(Icons.add),
                  label: Text(Strings.newChat.tr),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.blue, width: 1),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                );
              }),
            ),
            Divider(
              height: 1,
              color: AppTheme.grey.withOpacity(0.6),
            ),
            Expanded(
              child: Obx(() {
                if (controller.state.isLoadingConversations.value) {
                  return const Center(child: CircularProgressIndicator());
                }else if (controller.state.isErrorGetConversations.value){
return Center(
                    child: Column(
                      children: [
                        Text(
                          Strings.sometimesThereIsAnError.tr, 
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                          
                             ElevatedButton(
                              onPressed:  () async {
                                      await controller.service.loadConversations(controller.state);
                                    },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side:
                                      const BorderSide(color: Colors.green, width: 1),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: Text(Strings.pleaseTryAgain.tr),
                            )
                         
                      ],
                    ),
                  );
                }
                
                 else if (drawerList.isEmpty) {
                  return Center(
                    child: 
                        Text(
                          Strings.noConversations.tr, // Assuming you add this string to your localization
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),

                     
                     
                  
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 75.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(0.0),
                            itemCount: drawerList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return inkwell(drawerList[index]);
                            },
                          ),
                        ),
                        if (controller.state.hasMoreConversations.value)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(() {
                            return ElevatedButton(
                              onPressed: controller.state.isLoadingMore.value
                                  ? null
                                  : () async {
                                      await controller.loadMoreConversations();
                                    },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side:
                                      const BorderSide(color: Colors.blue, width: 1),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: controller.state.isLoadingMore.value
                                  ? const CircularProgressIndicator()
                                  :  Text(Strings.loadMore.tr),
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  void onTapped() {
    // Handle sign-out
  }

  Widget inkwell(DrawerList listData) {
    final currentConversation = controller.state.getCurrentConversation;
    final isSelected = currentConversation.id == listData.id;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          final conversation = controller.state.listConversations
              .firstWhere((c) => c.id == listData.id);
          controller.state.setCurrentConversation(conversation);
          controller.loadQuestionsAndAnswers();
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 6.0, height: 46.0),
                  const Padding(padding: EdgeInsets.all(4.0)),
                  if (listData.isAssetsImage)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset(
                        listData.imageName,
                        color: isSelected ? Colors.blue : AppTheme.nearlyBlack,
                      ),
                    )
                  else
                    Icon(
                      listData.icon?.icon,
                      color: isSelected ? Colors.green : AppTheme.nearlyBlack,
                    ),
                  const Padding(padding: EdgeInsets.all(4.0)),
                  Expanded(
                    child: Text(
                      listData.labelName,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: isSelected ? Colors.black : AppTheme.nearlyBlack,
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              AnimatedBuilder(
                animation: widget.iconAnimationController!,
                builder: (BuildContext context, Widget? child) {
                  return Transform(
                    transform: Matrix4.translationValues(
                      (MediaQuery.of(context).size.width * 0.75 - 64) *
                          (1.0 - widget.iconAnimationController!.value - 1.0),
                      0.0,
                      0.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.75 - 64,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                            bottomLeft: Radius.circular(28),
                            bottomRight: Radius.circular(28),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }

  void navigationtoScreen(DrawerIndex index) {
    if (widget.callBackIndex != null) {
      widget.callBackIndex!(index);
    }
  }
}

enum DrawerIndex {
  ChatAiChatView,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
    this.id = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
  String id;
}
