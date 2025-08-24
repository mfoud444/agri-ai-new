import 'package:agri_ai/app/modules/chat/views/widgets/erro_get_messages.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agri_ai/app/data/models/conversation_model.dart';
import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/messages/answer_message.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/custom_input_ai.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/messages/question_message.dart';
import 'package:agri_ai/app/modules/chat/views/widgets/messages/welcome_chat.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MessagesView extends GetView<ChatAiChatController> {
  final ScrollController _scrollController = ScrollController();

  MessagesView({super.key});

// Create some fake AnswerMedia

// Create some fake Questions
  List<Question> fakeQuestions = [
    Question(
      id: 'q1',
      conversationId: 'c1',
      content: 'What is the optimal temperature for growing tomatoes?',
      createdAt: '2024-01-01T12:00:00Z',
      updatedAt: '2024-01-01T12:00:00Z',
      questionMedia: [
        QuestionMedia(
          id: 'qm1',
          questionId: 'q1',
          mediaUrl: 'https://example.com/question-image.jpg',
          mediaType: 'image',
          createdAt: '2024-01-01T12:00:00Z',
          updatedAt: '2024-01-01T12:00:00Z',
        ),
      ],
      answer: [
        Answer(
          id: 'a1',
          questionId: 'q1',
          content: 'This is a sample answer for the question.',
          isLoading: false,
          isError: false,
          isLike: true,
          status: 'completed',
          createdAt: '2024-01-01T12:00:00Z',
          updatedAt: '2024-01-01T12:00:00Z',
          answerMedia: [
            AnswerMedia(
              id: 'am1',
              answerId: 'a1',
              mediaUrl: 'https://example.com/image1.jpg',
              mediaType: 'image',
              createdAt: '2024-01-01T12:00:00Z',
              updatedAt: '2024-01-01T12:00:00Z',
            ),
          ],
        ),
      ],
    ),
    Question(
      id: 'q2',
      conversationId: 'c1',
      content: 'How much water do tomato plants need daily?',
      createdAt: '2024-01-02T12:00:00Z',
      updatedAt: '2024-01-02T12:00:00Z',
      questionMedia: null, // No media for this question
      answer: [
        Answer(
          id: 'a1',
          questionId: 'q1',
          content: 'This is a sample answer for the question.',
          isLoading: false,
          isError: false,
          isLike: true,
          status: 'completed',
          createdAt: '2024-01-01T12:00:00Z',
          updatedAt: '2024-01-01T12:00:00Z',
          answerMedia: [
            AnswerMedia(
              id: 'am1',
              answerId: 'a1',
              mediaUrl: 'https://example.com/image1.jpg',
              mediaType: 'image',
              createdAt: '2024-01-01T12:00:00Z',
              updatedAt: '2024-01-01T12:00:00Z',
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Obx(() {
          final conversation = controller.state.getCurrentConversation;



          if (controller.state.isErrorGetQuestionAnswer.value) {
            return const ErrorGetMessagesView();
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            }
          });

          // Determine if the last answer has 'pending' status
          bool showInputField = true;
          if (!controller.state.isUserAgri.value) {
            if (controller.state.isCurrentAgriConv()) {
              if (conversation.question?.isNotEmpty ?? false) {
                final lastQuestion = conversation.question!.last;
                final lastAnswer = lastQuestion.answer?.last;
                if (lastAnswer?.status == 'pending') {
                  showInputField = false;
                }
              }
            }
          }

          return Column(
            children: [
              Expanded(
                child: (conversation.question == null ||
                            conversation.question!.isEmpty) &&
                        !controller.state.isLoadingQuestions.value
                    ? const WelcomeChat()
                    : Container(
                        margin: EdgeInsets.only(top: 50.h),
                        child: controller.state.isLoadingQuestions.value
                            ? Skeletonizer(
                                effect: const ShimmerEffect(
                                  baseColor: Color.fromARGB(255, 219, 238, 220),
                                  highlightColor:
                                      Color.fromARGB(255, 200, 236, 201),
                                  duration: Duration(seconds: 1),
                                ),
                                enabled:
                                    controller.state.isLoadingQuestions.value,
                                child: ListView.builder(
                                  itemCount: fakeQuestions.length,
                                  itemBuilder: (context, index) {
                                    final question = fakeQuestions[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _buildQuestionWidget(question),
                                        _buildAnswerWidget(question.answer!),
                                        SizedBox(height: 16.h),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: conversation.question?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final question =
                                      conversation.question![index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _buildQuestionWidget(question),
                                      if (question.answer != null &&
                                          question.answer!.isNotEmpty)
                                        _buildAnswerWidget(question.answer!),
                                      SizedBox(height: 16.h),
                                    ],
                                  );
                                },
                              ),
                      ),
              ),
              if (showInputField)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 75.0),
                  child: CustomInputField(
                    hintText: Strings.askAnything.tr,
                    onSubmitted: (value) {
                      controller.submitQuestion(value);
                    },
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildQuestionWidget(Question question) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: QuestionMessage(question: question),
    );
  }

  Widget _buildAnswerWidget(List<Answer> answers) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: AnswerMessage(answers: answers),
    );
  }
}
