import 'package:agri_ai/app/controllers/auth_controller.dart';
import 'package:agri_ai/app/data/local/my_hive.dart';
import 'package:agri_ai/app/data/models/conversation_model.dart';
import 'package:agri_ai/app/data/providers/conversation_provider.dart';
import 'package:agri_ai/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_setting_model.dart';


class AppSettingProvider extends GetConnect {
  final SupabaseClient client = Supabase.instance.client;

  var appSetting = Rx<AppSetting?>(null);
  var agriConversation = Conversation(
  id: '',
  userId: 'default_user',
  title: 'New Conversation',
  type: 'Agri-Expert',
  createdAt: DateTime.now().toIso8601String(),
  updatedAt: DateTime.now().toIso8601String(),
  question: [],
).obs;

  final AuthController authController = Get.find<AuthController>();

  final ConversationProvider convProvider = Get.find<ConversationProvider>();

  @override
  Future<void> onInit() async {
    super.onInit();
      
  }
Future<void> getAppSetting() async {
  try {
 
    final response = await client.from('app_setting').select('''
          default_ai_model(
            id,
            company_id,
            company:ai_company(
              id,
              name,
              company_url,
              logo_url,
              api_url,
              is_activate,
              api_key,
              created_at,
              updated_at
            ),
            name,
            model_code,
            description,
            is_activate,
            version,
            input_data,
            output_data,
            max_tokens,
            temperature,
            top_p,
            top_k,
            repetition_penalty,
            stop,
            stream
          ),
          default_message,
          terms_of_use_url,
          privacy_policy_url,
          created_at,
          updated_at
        ''').single();

    if (kDebugMode) {
      print(response);
    }
    
    appSetting.value = AppSetting.fromJson(response);

    // Call the new function to check and fetch the client's conversation
    await checkAndFetchClientConversation();

  } catch (e) {
    // Navigate to error page
    Get.offAllNamed(Routes.ERROR_LAUNCH);
  }
}

Future<void> checkAndFetchClientConversation() async {
  if (MyHive.getCurrentUser()?.userType == 'Client') {
 
    final agriConv = await convProvider.getMyAgriConversation();
    agriConversation.value = agriConv;
      
  }
  
}

  Future<Response<AppSetting>> postAppSetting(AppSetting appsetting) async {
    final response =
        await client.from('app_setting').insert(appsetting.toJson());
    if (response.error != null) {
      // Handle error
      return Response(
          statusCode: response.statusCode, statusText: response.error!.message);
    }
    return Response<AppSetting>(
        statusCode: response.statusCode,
        body: AppSetting.fromJson(response.data));
  }

  Future<Response> deleteAppSetting(String id) async {
    final response = await client.from('app_setting').delete().eq('id', id);
    if (response.error != null) {
      // Handle error
      return Response(
          statusCode: response.statusCode, statusText: response.error!.message);
    }
    return Response(statusCode: response.statusCode);
  }
}
