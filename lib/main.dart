import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/api_service.dart';
import 'package:instagram_clone/app_constants.dart';
import 'package:instagram_clone/app_theme.dart';
import 'package:instagram_clone/auth_controller.dart';
import 'package:instagram_clone/home_screen.dart';
import 'package:instagram_clone/login_screen.dart';
import 'package:instagram_clone/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX controllers
  Get.put(ThemeController());
  Get.put(ApiService(), permanent: true);
  Get.put(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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