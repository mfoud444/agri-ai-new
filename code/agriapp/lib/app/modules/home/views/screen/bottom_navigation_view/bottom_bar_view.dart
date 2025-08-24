import 'package:agri_ai/config/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../models/tabIcon_data.dart';
import 'package:flutter/material.dart';
class BottomBarView extends StatefulWidget {
  const BottomBarView(
      {super.key, this.tabIconsList, this.changeIndex, this.addClick});

  final Function(int index)? changeIndex;
  final Function()? addClick;
  final List<TabIconData>? tabIconsList;
  
  @override
  _BottomBarViewState createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationController?.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure that widget.tabIconsList has at least 4 items
    final tabIconsList = widget.tabIconsList ?? [];

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              child: PhysicalShape(
                color: AppTheme.white,
                elevation: 16.0,
                clipper: TabClipper(),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 72,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, top: 4),
                        child: Row(
                          children: <Widget>[
                            if (tabIconsList.isNotEmpty) Expanded(
                              child: TabIcons(
                                  tabIconData: tabIconsList[0],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(tabIconsList[0]);
                                    widget.changeIndex?.call(0);
                                  }),
                            ),
                            if (tabIconsList.length > 1) Expanded(
                              child: TabIcons(
                                  tabIconData: tabIconsList[1],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(tabIconsList[1]);
                                    widget.changeIndex?.call(1);
                                  }),
                            ),
                            if (tabIconsList.length > 2) Expanded(
                              child: TabIcons(
                                  tabIconData: tabIconsList[2],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(tabIconsList[2]);
                                    widget.changeIndex?.call(2);
                                  }),
                            ),
                            if (tabIconsList.length > 3) Expanded(
                              child: TabIcons(
                                  tabIconData: tabIconsList[3],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(tabIconsList[3]);
                                    widget.changeIndex?.call(3);
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void setRemoveAllSelection(TabIconData? tabIconData) {
    if (!mounted) return;
    setState(() {
      widget.tabIconsList?.forEach((TabIconData tab) {
        tab.isSelected = false;
        if (tabIconData!.index == tab.index) {
          tab.isSelected = true;
        }
      });
    });
  }
}



class TabIcons extends StatefulWidget {
  const TabIcons({super.key, this.tabIconData, this.removeAllSelect});

  final TabIconData? tabIconData;
  final Function()? removeAllSelect;

  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData?.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (!mounted) return;
          widget.removeAllSelect!();
          widget.tabIconData?.animationController?.reverse();
        }
      });
    super.initState();
  }

  void setAnimation() {
    widget.tabIconData?.animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8), // Large left and right padding
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData!.isSelected) {
              setAnimation();
            }
          },
          child: IgnorePointer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: widget.tabIconData!.isSelected
                        ? AppTheme.nearlyDarkGreen.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: widget.tabIconData!.imagePath != null
                      ? Image.asset(
                          widget.tabIconData!.isSelected
                              ? widget.tabIconData!.imageSelectedPath!
                              : widget.tabIconData!.imagePath!,
                          width: 24,
                          height: 24,
                          color: widget.tabIconData!.isSelected
                              ? AppTheme.nearlyDarkGreen
                              : AppTheme.nearlyBlack,
                        )
                      : Icon(
                          widget.tabIconData!.isSelected
                              ? widget.tabIconData!.selectedIcon
                              : widget.tabIconData!.icon,
                          size: 24,
                          color: widget.tabIconData!.isSelected
                              ? AppTheme.nearlyDarkGreen
                              : AppTheme.nearlyBlack,
                        ),
                ),
                SizedBox(height: 1.h),
                Text(
                  widget.tabIconData!.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.tabIconData!.isSelected
                        ? AppTheme.nearlyDarkGreen
                        : AppTheme.nearlyBlack,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class TabClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => false;
}
