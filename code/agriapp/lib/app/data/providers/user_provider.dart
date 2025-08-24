import 'package:agri_ai/app/controllers/auth_controller.dart';
import 'package:agri_ai/app/data/local/my_shared_pref.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class UserProvider extends GetConnect {
    final SupabaseClient client = Supabase.instance.client;
  @override
  void onInit() {
 
  }



Future<void> updateFcmToken() async {
  try {
       var token = MySharedPref.getFcmToken();
      //   Get.snackbar(
      //   'Error',
      // 'Error inserting answer: $token',
      //   snackPosition: SnackPosition.BOTTOM,
   
      //   duration: const Duration(seconds: 30),
      // );
    await client
        .from('users')
        .update({
          'fcm_token': token,
        })
        .eq('id', Get.find<AuthController>().getCurrentUserId());
      

  
  } catch (e) {
    print('An error occurred: $e');
  }
}



}
