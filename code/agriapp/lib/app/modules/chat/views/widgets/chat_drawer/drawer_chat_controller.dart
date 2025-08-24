import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';
import 'package:agri_ai/config/theme/app_theme.dart';
import 'package:get/get.dart';

import 'chat_drawer.dart';
import 'package:flutter/material.dart';

class DrawerChatController extends StatefulWidget {
  const DrawerChatController({
    super.key,
    this.drawerWidth = 200,
    this.onDrawerCall,
    this.screenView,
    this.animatedIconData = AnimatedIcons.arrow_menu,
    this.menuView,
    this.drawerIsOpen,
    this.screenIndex,
  });

  final double drawerWidth;
  final Function(DrawerIndex)? onDrawerCall;
  final Widget? screenView;
  final Function(bool)? drawerIsOpen;
  final AnimatedIconData? animatedIconData;
  final Widget? menuView;
  final DrawerIndex? screenIndex;

  @override
  _DrawerChatControllerState createState() => _DrawerChatControllerState();
}

class _DrawerChatControllerState extends State<DrawerChatController>
    with TickerProviderStateMixin {
  ScrollController? scrollController;
  AnimationController? iconAnimationController;
  AnimationController? animationController;

  double scrolloffset = 0.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    iconAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 0));
    iconAnimationController
      ?.animateTo(1.0,
          duration: const Duration(milliseconds: 0),
          curve: Curves.fastOutSlowIn);
    scrollController =
        ScrollController(initialScrollOffset: widget.drawerWidth);
    scrollController!
      .addListener(() {
        if (scrollController!.offset <= 0) {
          if (scrolloffset != 1.0) {
            setState(() {
              scrolloffset = 1.0;
              try {
                widget.drawerIsOpen!(true);
              } catch (_) {}
            });
          }
          iconAnimationController?.animateTo(0.0,
              duration: const Duration(milliseconds: 0),
              curve: Curves.fastOutSlowIn);
        } else if (scrollController!.offset > 0 &&
            scrollController!.offset < widget.drawerWidth.floor()) {
          iconAnimationController?.animateTo(
              (scrollController!.offset * 100 / (widget.drawerWidth)) / 100,
              duration: const Duration(milliseconds: 0),
              curve: Curves.fastOutSlowIn);
        } else {
          if (scrolloffset != 0.0) {
            setState(() {
              scrolloffset = 0.0;
              try {
                widget.drawerIsOpen!(false);
              } catch (_) {}
            });
          }
          iconAnimationController?.animateTo(1.0,
              duration: const Duration(milliseconds: 0),
              curve: Curves.fastOutSlowIn);
        }
      });
    // WidgetsBinding.instance.addPostFrameCallback((_) => getInitState());
    super.initState();
  }

  Future<bool> getInitState() async {
    scrollController?.jumpTo(
      widget.drawerWidth,
    );
    return true;
  }
@override
Widget build(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  bool isLightMode = brightness == Brightness.light;
  final ChatAiChatController controller = Get.find();

  return Scaffold(
    backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
    body: SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width + widget.drawerWidth,
        // We use width as screen width and add drawerWidth (from navigation_home_screen)
        child: Row(
          children: <Widget>[
            SizedBox(
              width: widget.drawerWidth,
              // We divided first drawer Width with HomeDrawer and second full-screen Width with all home screen, we called screen View
              height: MediaQuery.of(context).size.height,
              child: AnimatedBuilder(
                animation: iconAnimationController!,
                builder: (BuildContext context, Widget? child) {
                  return Transform(
                    // Transform we use for the stable drawer, we do not need to move with scroll view
                    transform: Matrix4.translationValues(
                        scrollController!.offset, 0.0, 0.0),
                    child: ChatDrawer(
                      screenIndex: widget.screenIndex ?? DrawerIndex.ChatAiChatView,
                      iconAnimationController: iconAnimationController,
                      callBackIndex: (DrawerIndex indexType) {
                        onDrawerClick();
                        try {
                          widget.onDrawerCall!(indexType);
                        } catch (e) {}
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  // This IgnorePointer we use as touch(user Interface) widget.screen View
                  IgnorePointer(
                    ignoring: scrolloffset == 1 || false,
                    child: widget.screenView,
                  ),
                  // Alternative touch(user Interface) for widget.screen
                  if (scrolloffset == 1.0)
                    InkWell(
                      onTap: () {
                        onDrawerClick();
                      },
                    ),
                  // This just menu and arrow icon animation
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: AppBar().preferredSize.height - 8,
                          height: AppBar().preferredSize.height - 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                  AppBar().preferredSize.height),
                              child: Center(
                                // If you use your own menu view UI you add form initialization
                                child: widget.menuView ?? AnimatedIcon(
                                        color: isLightMode
                                            ? AppTheme.darkGrey
                                            : AppTheme.white,
                                        icon: widget.animatedIconData ??
                                            AnimatedIcons.arrow_menu,
                                        progress: iconAnimationController!,
                                      ),
                              ),
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                onDrawerClick();
                              },
                            ),
                          ),
                        ),
                        // Expanded to take up remaining space and center title
                        Expanded(
                         
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                controller.state.currentConversation.value?.title ?? '',
                                style: TextStyle(
                                  color: isLightMode
                                      ? AppTheme.darkGrey
                                      : AppTheme.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  void onDrawerClick() {
    //if scrollcontroller.offset != 0.0 then we set to closed the drawer(with animation to offset zero position) if is not 1 then open the drawer
    if (scrollController!.offset != 0.0) {
      scrollController?.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController?.animateTo(
        widget.drawerWidth,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}
