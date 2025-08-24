import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final bool isVisible; // Controls visibility
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Widget? actionWidget; // Optional action widget (e.g., GestureDetector)

  const ErrorMessage({
    super.key,
    required this.message,
    this.isVisible = false, // Default to hidden
    this.padding = const EdgeInsets.all(12.0),
    this.borderRadius = 8.0,
    this.actionWidget, // Add the action widget parameter
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink(); // Hide if not visible

    return Container(
      width: double.infinity, // Full width
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.red[300], // Background color
        borderRadius: BorderRadius.circular(borderRadius), // Border radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            Strings.error, // Header text
            style: TextStyle(
              color: Colors.white, // Header text color
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0.h), // Space between header and message
          Text(
            message,
            style: const TextStyle(
              color: Colors.white, // Message text color
              fontSize: 14.0,
            ),
          ),
          if (actionWidget != null) ...[
            SizedBox(height: 8.0.h), // Space before action widget
            actionWidget!, // Display the action widget if provided
          ],
        ],
      ),
    );
  }
}
