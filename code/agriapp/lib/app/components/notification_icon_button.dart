import 'package:agri_ai/app/routes/app_pages.dart';
import 'package:agri_ai/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:flutter_screenutil/flutter_screenutil.dart'; 

// Define a reusable widget for the notification icon button
class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w), 
      child: InkWell(
        highlightColor: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        onTap: () {
          Get.toNamed(Routes.LIST_NOTIFICATION); 
        },
        child:  Container(
                  // decoration: BoxDecoration(
                  //   color: widget.tabIconData!.isSelected
                  //       ? AppTheme.nearlyDarkGreen.withOpacity(0.1)
                  //       : Colors.transparent,
                  //   borderRadius: BorderRadius.circular(8.r),
                  // ),
                  padding: const EdgeInsets.all(8),
                  child:  Image.asset(
                         'assets/images/notification.png',
                             width: 22.w, 
            height: 26.h, 
                          color: const Color.fromARGB(255, 241, 248, 240)
                              
                        )
                     
                ),
        
      ),
    );
  }
}
