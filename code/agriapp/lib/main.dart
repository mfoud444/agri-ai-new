import 'package:agri_ai/app/data/providers/app_setting_provider.dart';
import 'package:agri_ai/app/data/providers/conversation_provider.dart';
import 'package:agri_ai/app/modules/chat/controllers/chat_ai_chat_controller.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:agri_ai/utils/app_size.dart';
import 'package:agri_ai/utils/fcm_helper.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:agri_ai/utils/awesome_notifications_helper.dart';
import 'app/data/local/my_hive.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/data/models/user_model.dart';
import 'app/routes/app_pages.dart';
import 'config/theme/my_theme.dart';
import 'config/translations/localization_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../app/controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';  

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await init();
 
 runApp(const MyApp());
}

Future<void> init() async {
  // Initialize cameras
  cameras = await availableCameras();

  // Initialize local db (Hive) and register custom adapters
  await MyHive.init(
    registerAdapters: (hive) {
      hive.registerAdapter(UserAdapter());
    },
  );

  // Initialize shared preferences
  await MySharedPref.init();

    // Load environment variables
  await dotenv.load();
  
  // Initialize Supabase
  String supaUri = dotenv.get('SUPABASE_URL');
  String supaAnon = dotenv.get('SUPABASE_ANONKEY');
  await Supabase.initialize(
    url: supaUri,
    anonKey: supaAnon,
  );

    // Optionally initialize Stripe (uncomment if needed)
  // String stripePublishableKey = dotenv.get('STRIPE_PUBLISHABLE_KEY');
  // Stripe.publishableKey = stripePublishableKey;
  // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  // Stripe.urlScheme = 'flutterstripe';
  // await Stripe.instance.applySettings();


    // Initialize AuthController with GetX
  final authC = Get.put(AuthController(), permanent: true);
  
       Get.put<ConversationProvider>(ConversationProvider());
 // Register AppSettingProvider with GetX and fetch settings
  Get.put<AppSettingProvider>(AppSettingProvider());
  Get.put(ChatAiChatController());
  // Hide the keyboard if it's showing
  SystemChannels.textInput.invokeMethod('TextInput.hide');

  // Initialize FCM services
  await FcmHelper.initFcm();

  // Initialize local notifications service
  await AwesomeNotificationsHelper.init();
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        AppSize().init(context);
        return GetMaterialApp(
          title: Strings.appName.tr,
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            bool themeIsLight = MySharedPref.getThemeIsLight();
            return Theme(
              data: MyTheme.getThemeData(isLight: themeIsLight),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: widget!,
              ),
            );
          },
          initialRoute: Routes.SPLASH_PAGE,
          getPages: AppPages.routes,
          locale: MySharedPref.getCurrentLocal(),
          translations: LocalizationService.getInstance(),
        );
      },
    );
  }
}

final supabase = Supabase.instance.client;
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}