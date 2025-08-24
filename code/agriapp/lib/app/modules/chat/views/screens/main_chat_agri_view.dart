import 'package:agri_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:agri_ai/app/controllers/auth_controller.dart';
import 'package:agri_ai/app/data/models/conversation_model.dart';
import 'package:agri_ai/app/data/providers/conversation_provider.dart';
import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/messages_view.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';

class MainChatAgriView extends StatefulWidget {
  const MainChatAgriView({super.key});

  @override
  _MainChatAgriViewState createState() => _MainChatAgriViewState();
}

class _MainChatAgriViewState extends State<MainChatAgriView> {
  @override
  Widget build(BuildContext context) {
    return  AgriView();
  }
}

class AgriView extends GetView<ChatAiChatController> {
  final AuthController authController = Get.find();
  final ConversationProvider convProvider = Get.find();

   AgriView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      PreferredSizeWidget appBar;
      Widget body;
      if (controller.state.isUserAgri.value) {
        if (controller.state.showChatMessageUserToAgri.value) {
           appBar = _buildAppBarChatAgriUser('');
          body = MessagesView();
        } else {
          appBar = _buildChatListAppBar();
          if (controller.state.isLoadingAgriConversations.value) {
            // Show loading indicator while conversations are being fetched
            body = const Center(child: CircularProgressIndicator());
          } else if (controller.state.listAgriConversations.isEmpty) {
            // Show a message when there are no conversations
            body = const Center(child: Text('No conversations found'));
          } else {
            // Show the list of conversations
            body = ListView.builder(
              itemCount: controller.state.listAgriConversations.length,
              itemBuilder: (context, index) {
                final conversation =
                    controller.state.listAgriConversations[index];
                return _buildConversationItem(conversation);
              },
            );
          }
        }
      } else {
            
        appBar = _buildAppBar();
        body = MessagesView();
      }

      return Scaffold(
        appBar: appBar,
        body: body,
      );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/gardener.png'),
              backgroundColor: Colors.white,
            ),
            SizedBox(width: 8.w), // Adjust spacing between the avatar and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.agriculturalExpert.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Colors.greenAccent,
                      size: 12,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      Strings.online.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


PreferredSizeWidget _buildAppBarChatAgriUser( String? avatar) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
    controller.state.showChatMessageUserToAgri.value = false;
      },
    ),
    title: Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: (avatar != null && avatar.isNotEmpty)
                ? NetworkImage(avatar)
                : const AssetImage('assets/images/boy.png') as ImageProvider<Object>,
            radius: 25,
          ),
          SizedBox(width: 8.w), // Adjust spacing between the avatar and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.state.currentConversation.value?.title ??'',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  
  PreferredSizeWidget _buildChatListAppBar() {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        child: Row(
          children: [
            SizedBox(width: 8.w), // Adjust spacing between the icon and text
             Text(
              Strings.chatList.tr, // Replace with the appropriate string for chat list
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      
      actions: [
       
                                 Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w),
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
    );
  }
Widget _buildConversationItem(Conversation conversation) {
  return GestureDetector(
    onTap: () => _handleConversationTap(conversation),
    child: FutureBuilder<String?>(
      future: authController.getAvatarUser(conversation.userId ?? ''),
      builder: (context, avatarSnapshot) {
        return FutureBuilder<String?>(
          future: convProvider.getLastQuestionContentByConversationId(conversation.id ?? ''),
          builder: (context, questionSnapshot) {
            if (_isLoading(avatarSnapshot, questionSnapshot)) {
              return _buildLoadingPlaceholder(conversation);
            } else if (_hasError(avatarSnapshot, questionSnapshot)) {
              return _buildErrorPlaceholder(conversation);
            } else {
              return _buildConversationContent(avatarSnapshot, questionSnapshot, conversation);
            }
          },
        );
      },
    ),
  );
}

void _handleConversationTap(Conversation conversation) {
  controller.state.showChatMessageUserToAgri.value = true;
  Conversation newConversation = conversation..question = [];
  controller.getQuestionAndAnswerAgri(newConversation);
  controller.state.nameHeaderQuestion.value = conversation.title ?? 'Client';
  controller.state.nameHeaderAnswer.value = 'You';
}

bool _isLoading(AsyncSnapshot avatarSnapshot, AsyncSnapshot questionSnapshot) {
  return avatarSnapshot.connectionState == ConnectionState.waiting ||
         questionSnapshot.connectionState == ConnectionState.waiting;
}

bool _hasError(AsyncSnapshot avatarSnapshot, AsyncSnapshot questionSnapshot) {
  return avatarSnapshot.hasError || questionSnapshot.hasError;
}

Widget _buildLoadingPlaceholder(Conversation conversation) {
  return _buildConversationRow(
    avatar: const CircleAvatar(backgroundColor: Colors.grey, radius: 25),
    title: conversation.title ?? 'No Title',
    description: 'Loading...',
  );
}

Widget _buildErrorPlaceholder(Conversation conversation) {
  return _buildConversationRow(
    avatar: const CircleAvatar(backgroundImage: AssetImage('assets/images/boy.png'), radius: 25),
    title: conversation.title ?? 'No Title',
    description: 'Error loading content',
  );
}

Widget _buildConversationContent(AsyncSnapshot<String?> avatarSnapshot, AsyncSnapshot<String?> questionSnapshot, Conversation conversation) {
  return _buildConversationRow(
    avatar: CircleAvatar(
      backgroundImage: (avatarSnapshot.data != null && avatarSnapshot.data!.isNotEmpty)
          ? NetworkImage(avatarSnapshot.data!)
          : const AssetImage('assets/images/boy.png') as ImageProvider<Object>,
      radius: 25,
    ),
    title: conversation.title ?? 'No Title',
    description: questionSnapshot.data ?? 'No Description',
  );
}
Widget _buildConversationRow({
  required Widget avatar,
  required String title,
  required String description,
}) {
  return Padding(
    padding:EdgeInsets.symmetric( horizontal: 16.w),
    child: Container(
      width: double.infinity, 
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300, 
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Aligns children to the start of the row
        crossAxisAlignment: CrossAxisAlignment.center, // Center aligns children vertically
        children: [
          avatar,
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


}
