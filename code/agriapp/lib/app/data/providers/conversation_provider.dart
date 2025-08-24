import 'package:agri_ai/app/controllers/auth_controller.dart';
import 'package:agri_ai/app/data/local/my_hive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/conversation_model.dart';

class ConversationProvider extends GetConnect {
  final supabase = Supabase.instance.client;

   
  AuthController auth = Get.find<AuthController>();
  @override
  void onInit() async {
    super.onInit();
  
  }




  Future<List<Conversation>> getConversations({
    int page = 1,
    String type = 'AI',
  }) async {
    final response = await supabase
        .from('conversation')
        .select()
        .eq('user_id', auth.getCurrentUserId())
        .eq('type', type)
        .order('created_at', ascending: false)
        .range((page - 1) * 10, page * 10 - 1);

    print(response);

    return (response as List)
        .map((item) => Conversation.fromJson(item))
        .toList();
  }


  Future<Conversation> getMyAgriConversation() async {
    final response = await supabase
        .from('conversation')
        .select()
        .eq('user_id', auth.getCurrentUserId())
        .eq('type',  'Agri-Expert')
        .single();

    print(response);

    return  Conversation.fromJson(response);
        
  }
  Future<Conversation?> getConversationById(String conversationId) async {
    final response = await supabase
        .from('conversation')
        .select()
        .eq('id', conversationId)
        .single();


    return Conversation.fromJson(response);
  }

  Future<Conversation> addNewConversation(String title) async {
    final response = await supabase
        .from('conversation')
        .insert({
          'user_id': auth.getCurrentUserId(),
          'title': title,
        })
        .select()
        .single();

    return Conversation.fromJson(response);
  }

 Future<List<Question>> getListQuestionAnswerByConversationId(String conversationId) async {
  final response = await supabase
      .from('question')
      .select('id, conversation_id, content, created_at, updated_at, question_media(*), answer(id, content,status, created_at, updated_at, answer_media(*))')
      .eq('conversation_id', conversationId);

  print(response);
  final data = response as List<dynamic>;
  return data.map((item) => Question.fromJson(item)).toList();
}


Future<String?> getLastQuestionContentByConversationId(String conversationId) async {
  try {
    // Fetch the content of the last question from Supabase
    final response = await supabase
        .from('question')
        .select('content') // Select only the content column
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: false) // Order by timestamp in descending order
        .limit(1) // Limit to only one item
        .single(); // Expect a single item

  
      final data = response;
      return data['content'] as String?;
   
  } catch (e) {
    print('Error fetching last question content: $e');
  }
  return null; // Return null if no content is found or an error occurs
}


  Future<String> createConversation(String title, String type) async {
    final response = await supabase
        .from('conversation')
        .insert({
          'user_id': auth.getCurrentUserId(),
          'title': title,
          'type': type,
        })
        .select()
        .single();

    return response['id'] as String;
  }

  Future<String> insertQuestion(
      String conversationId, String content, List<QuestionMedia> media) async {
    final response = await supabase
        .from('question')
        .insert({
          'conversation_id': conversationId,
          'content': content,
        })
        .select()
        .single();

    String questionId = response['id'] as String;

    // Insert media if any
    if (media.isNotEmpty) {
      await supabase.from('question_media').insert(
            media
                .map((m) => {
                      'question_id': questionId,
                      'media_url': m.mediaUrl,
                      'media_type': m.mediaType,
                    })
                .toList(),
          );
    }

    return questionId;
  }

 Future<void> insertAnswer(Answer answer, List<QuestionMedia>? media ) async {
  try {
     await supabase
        .from('answer')
        .insert({
          'id': answer.id,
          'question_id': answer.questionId,
          'content': answer.content,
          'status': answer.status,
        });
      

    // if (response.error != null) {
    //   throw Exception('Failed to insert answer: ${response.error!.message}');
    // }
    
    // If needed, handle media files insertion or other related operations here
    if (media != null && media.isNotEmpty) {
      await insertQuestionMedia(media);
    }

    if(answer.answerMedia != null){
       
      await insertAnswerMedia(answer.answerMedia!);
    }

  } catch (e) {
       Get.snackbar(
        'Error',
      'Error inserting answer: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 30),
      );
    // Handle any exceptions or errors
    print('Error inserting answer: $e');
  }
}

Future<void> insertQuestionMedia(List<QuestionMedia> media) async {
  try {
    final response = await supabase
        .from('question_media')
        .upsert(media.map((m) => {
          'id': m.id,
          'question_id': m.questionId,
          'media_url': m.mediaUrl,
          'media_type': m.mediaType,
        }).toList());
      

    if (response.error != null) {
      throw Exception('Failed to insert question media: ${response.error!.message}');
    }
    
  } catch (e) {
    // Handle any exceptions or errors
    print('Error inserting question media: $e');
  }
}

Future<void> insertAnswerMedia(List<AnswerMedia> media) async {
  try {

      Get.snackbar(
        'Error',
      media[0].id ?? 'pp',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 10),
      );
    await supabase
        .from('answer_media')
        .upsert(media.map((m) => {
          'id': m.id,
          'answer_id': m.answerId,
          'media_url': m.mediaUrl,
          'media_type': m.mediaType,
        }).toList());
      

  
    
  } catch (e) {
       Get.snackbar(
        'Error',
      'Error inserting answer media: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 30),
      );
    // Handle any exceptions or errors
    print('Error inserting answer media: $e');
  }
}

  Future<void> updateAnswer(String answerId, String content,
      {String? status}) async {
    await supabase.from('answer').update({
      'content': content,
      'status': status,
    }).eq('id', answerId);
  }

  Future<void> insertQuestionAndAnswer({
    required String conversationId,
    required String questionId,
    required String questionContent,
    required String answerId,
    required String answerContent,
    List<QuestionMedia> media = const [],
    String? answerStatus,
  }) async {
    try {
      // Insert question with the given questionId
      await supabase.from('question').insert({
        'id': questionId,
        'conversation_id': conversationId,
        'content': questionContent,
      });

      // Insert media if any
      if (media.isNotEmpty) {
        // final mediaJson = media.map((m) => m.toJson()).toList();

        await supabase.from('question_media').insert(
              media
                  .map((m) => {
                        'question_id': m.questionId,
                        'media_url': m.mediaUrl,
                        'media_type': m.mediaType,
                      })
                  .toList(),
            );
      }

      // Insert answer with the given answerId
      await supabase.from('answer').insert({
        'id': answerId,
        'question_id': questionId,
        'content': answerContent,
        'status': answerStatus,
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        "Failed to insert question and answer",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      throw Exception('Failed to insert question and answer: $e');
    }
  }

Future<List<Conversation>> getAgriExpertConversations() async {
  // Query the view instead of the table
  final response = await supabase
      .from('conversation_with_questions')
      .select('*') // Select all fields from the view
      .order('updated_at', ascending: false);

  // Convert the response into a list of Conversation objects
  final conversations = (response as List)
      .map((item) => Conversation.fromJson(item))
      .toList();

  return conversations;
}

 
 
}

