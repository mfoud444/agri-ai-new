import 'package:agri_ai/app/data/local/my_hive.dart';
import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';
import 'package:agri_ai/app/modules/chat/views/screens/chat_view.dart';
import 'package:agri_ai/app/modules/home/controllers/home_controller.dart';
import 'package:agri_ai/app/modules/home/views/screen/get_premium_view.dart';
import 'package:agri_ai/app/modules/more/views/more_view.dart';
import 'package:agri_ai/app/routes/app_pages.dart';
import 'package:agri_ai/config/theme/app_theme.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'models/tabIcon_data.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';

import 'package:agri_ai/app/modules/home/views/screen/models/feature_list_data.dart';
import 'package:agri_ai/main.dart';

class FeatureListView extends StatefulWidget {
  const FeatureListView({
    super.key,
    this.mainScreenAnimationController,
    this.mainScreenAnimation,
  });

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _FeatureListViewState createState() => _FeatureListViewState();
}

class _FeatureListViewState extends State<FeatureListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<FeatureListData> featureListData = FeatureListData.tabIconsList;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  void _navigateToAppHomeScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppHomeScreen(defaultIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                itemCount: featureListData.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      featureListData.length > 10 ? 10 : featureListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return FeatureView(
                    featureListData: featureListData[index],
                    animation: animation,
                    animationController: animationController!,
                    onTap: () {
                      // Determine which defaultIndex to pass based on your logic
                      int defaultIndex = index == 0 ? 1 : 2; // Example logic
                      _navigateToAppHomeScreen(defaultIndex);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class FeatureView extends StatelessWidget {
  const FeatureView({
    super.key,
    this.featureListData,
    this.animationController,
    this.animation,
    this.onTap, // Add this line
  });

  final FeatureListData? featureListData;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final VoidCallback? onTap; // Add this line

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: HexColor(featureListData!.endColor).withOpacity(0.6),
                    offset: const Offset(1.1, 4.0),
                    blurRadius: 8.0,
                  ),
                ],
                gradient: LinearGradient(
                  colors: <HexColor>[
                    HexColor(featureListData!.startColor),
                    HexColor(featureListData!.endColor),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(featureListData!.imagePath),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            featureListData!.titleTxt,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: AppTheme.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            featureListData!.description!,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              letterSpacing: 0.2,
                              color: AppTheme.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: onTap, // Call the onTap function
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  Strings.learnMore.tr,
                                  style: const TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: 0.2,
                                    color: AppTheme.white,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 4, bottom: 3),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: AppTheme.white,
                                    size: 16,
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
          ),
        );
      },
    );
  }
}


class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Stack(
              children: <Widget>[
                controller.tabBody.value,
                Column(
          children: <Widget>[
            const Expanded(child: SizedBox()),
            BottomBarView(
              tabIconsList: controller.tabIconsList,
              changeIndex: (index) {
                controller.updateSelectedTabIndex(index);
                controller.setTabBody(index);
              },
            ),
          ],
        )
              ],
            );
        
        
        
      },
    );
  }
}

class AppHomeScreen extends StatefulWidget {
  final int defaultIndex;

  const AppHomeScreen({super.key, this.defaultIndex = 0});

  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late List<TabIconData> tabIconsList;
  late Widget tabBody;
  late int selectedTabIndex; 
  final chatAiChatController = Get.put(ChatAiChatController());
    final homeController = Get.put(HomeController());
 
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    tabIconsList = TabIconData.tabIconsList;
  chatAiChatController.state.updateUserType();
    _updateTabIconsList();
     selectedTabIndex = widget.defaultIndex;
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[selectedTabIndex].isSelected = true;

    setTabBody(tabIconsList[selectedTabIndex].index);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _updateTabIconsList() {
    setState(() {
    tabIconsList =   homeController.tabIconsList;
      // if (chatAiChatController.state.isUserAgri.value) {
      //   tabIconsList = TabIconData.tabIconsList
      //     ..removeWhere((tab) => tab.index == 0 || tab.index == 1);
      // } else {
      //   tabIconsList = TabIconData.tabIconsList;
      // }
    });
  }

  void setTabBody(int index) {
    switch (index) {
      case 1:
        chatAiChatController.initializeAISetup();
        tabBody = const ChatView();
        break;
      case 2:
        chatAiChatController.initializeAgriSetup();
        tabBody = const ChatView();
        break;
      case 3:
        tabBody = MoreView();
        break;
      case 0:
      default:
        tabBody = MyDiaryScreen(animationController: animationController);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Stack(
              children: <Widget>[
                tabBody,
                bottomBar(),
              ],
            );
          }
        },
      ),
    );
  }

  Future<bool> getData() async {
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(child: SizedBox()),
        BottomBarView(
          tabIconsList: tabIconsList,
          changeIndex: (index) {
            setState(() {
              // _updateTabIconsList();
              selectedTabIndex = tabIconsList[index].index;
              setTabBody(selectedTabIndex);
            });
          },
        ),
      ],
    );
  }
}

class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({super.key, this.animationController});

  final AnimationController? animationController;
  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<MyDiaryScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 9;

    listViews.add(
      SubscriptionView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController!,
                  curve: const Interval((1 / count) * 8, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController!),
    );

    listViews.add(
      FeatureListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: const Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Strings.welcome.tr,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 38,
                                  width: 38,
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(32.0)),
                                    onTap: () {
                                      Get.toNamed(Routes.PROFILE);
                                    },
                                    child: const Center(
                                      child: Icon(
                                        Icons.person,
                                     
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                SizedBox(
                                  height: 38,
                                  width: 38,
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(32.0)),
                                    onTap: () {
                                      Get.toNamed(Routes.LIST_NOTIFICATION);
                                    },
                                    child: const Center(
                                      child: Icon(
                                        Icons.notifications,
                                    
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
