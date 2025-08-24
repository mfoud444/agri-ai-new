
// import 'package:agri_ai/app/data/providers/conversation_provider.dart';
// import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'item_conversation.dart';

// class NavigationConversationScreen extends StatefulWidget {
//   @override
//   _NavigationConversationScreenState createState() => _NavigationConversationScreenState();
// }

// class _NavigationConversationScreenState extends State<NavigationConversationScreen> {
//   final ChatAiChatController controller = Get.put(ChatAiChatController());
//   final ConversationProvider provider = Get.find<ConversationProvider>();

//   @override
//   void initState() {
//     super.initState();
//     // Call loadConversations when the screen is initialized
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.service.loadConversations(controller.state);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
   
//       body: Obx(() {
//         if (controller.state.isLoading.value && controller.state.listConversations.isEmpty) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return Column(
//           children: [
//             Expanded(
//               child: ListView.separated(
//                 padding: EdgeInsets.all(16.r),
//                 itemCount: controller.state.listConversations.length,
//                 separatorBuilder: (context, index) => SizedBox(height: 16.h),
//                 itemBuilder: (context, index) {
//                   return ConversationItem(
//                     conversation: controller.state.listConversations[index],
//                     onTap: () {
//                       Get.toNamed('/chat', arguments: controller.state.listConversations[index]);
//                     },
//                   );
//                 },
//               ),
//             ),
//             if (controller.state.hasMoreConversations.value)
//               Padding(
//                 padding: EdgeInsets.all(16.r),
//                 child: ElevatedButton(
//                   onPressed: controller.state.isLoadingMore.value
//                       ? null
//                       : () => controller.loadMoreConversations(),
//                   child: controller.state.isLoadingMore.value
//                       ? SizedBox(
//                           width: 20.r,
//                           height: 20.r,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : Text('Load More'),
//                 ),
//               ),
//           ],
//         );
//       }),
//     );
//   }

//   void _addNewConversation() {
//     Get.dialog(
//       AlertDialog(
//         title: Text('New Conversation'),
//         content: TextField(
//           decoration: InputDecoration(hintText: 'Enter conversation title'),
//           onSubmitted: (value) {
//             Get.back();
//             controller.addNewConversation(value);
//           },
//         ),
//         actions: [
//           TextButton(
//             child: Text('Cancel'),
//             onPressed: () => Get.back(),
//           ),
//           TextButton(
//             child: Text('Create'),
//             onPressed: () {
//               final title = (Get.find<TextField>().controller?.text ?? '').trim();
//               if (title.isNotEmpty) {
//                 Get.back();
//                 controller.addNewConversation(title);
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }



