import 'package:agri_ai/app/routes/app_pages.dart';
import 'package:agri_ai/config/theme/app_theme.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
class SubscriptionView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const SubscriptionView({super.key, this.animationController, this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 24),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green[300],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, bottom: 12, right: 16, top: 12),
                                child: Text(
                                  Strings.upgradeToPremium.tr,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    letterSpacing: 0.5,
                                    color: Color.fromARGB(255, 241, 241, 236),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, bottom: 12, right: 16),
                                child: Text(
                                  Strings.premiumDescription.tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, bottom: 16, right: 16),
                                child: ElevatedButton(
                                  onPressed: () {
                                        Get.toNamed(Routes.PLANS);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.nearlyDarkGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                  child: Text(
                                    Strings.subscribeNow.tr,
                                    style: const TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -12,
                        left: 0,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset("assets/images/premium.png"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
