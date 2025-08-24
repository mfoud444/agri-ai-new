import 'package:agri_ai/app/data/models/conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ConversationItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationItem({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.chat_bubble_outline, size: 24.r, color: Colors.blue),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                conversation.title ?? 'Untitled Conversation',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}