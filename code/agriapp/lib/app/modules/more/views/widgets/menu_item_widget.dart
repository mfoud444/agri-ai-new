
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.green),
        title: Text(title, style: TextStyle(color: textColor)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
        onTap: onTap,
      ),
    );
  }
}