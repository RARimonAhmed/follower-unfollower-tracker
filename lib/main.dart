import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/api_service.dart';
import 'package:instagram_clone/app_constants.dart';
import 'package:instagram_clone/app_theme.dart';
import 'package:instagram_clone/auth_controller.dart';
import 'package:instagram_clone/deeplink_handler.dart';
import 'package:instagram_clone/follower_controller.dart';
import 'package:instagram_clone/home_screen.dart';
import 'package:instagram_clone/login_screen.dart';
import 'package:instagram_clone/storage_service.dart';
import 'package:instagram_clone/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX controllers
  Get.put(ThemeController());
  Get.put(ApiService(), permanent: true);
  final authController = Get.put(AuthController(), permanent: true);
  // Initialize SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Register SharedPreferences instance
  Get.put<SharedPreferences>(prefs);


  // Initialize StorageService
  await Get.putAsync<StorageService>(() async {
    final storage = StorageService();
    return storage.init();
  }, permanent: true);


  Get.put(DeepLinkHandler(authController: authController), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DeepLinkHandler _deepLinkHandler = Get.find();

  @override
  void initState() {
    super.initState();
    _deepLinkHandler.initDeepLinking();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return GetMaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode.value,
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        return Get.find<AuthController>().isLoggedIn.value
            ? const HomeScreen()
            : const LoginScreen();
      }),
    );
  }
}