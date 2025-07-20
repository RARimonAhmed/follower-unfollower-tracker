import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/api_service.dart';
import 'package:instagram_clone/app_constants.dart';
import 'package:instagram_clone/deeplink_handler.dart';
import 'package:instagram_clone/home_screen.dart';
import 'package:instagram_clone/login_screen.dart';

class AuthController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final ApiService _apiService = Get.find();

  final RxBool isLoggedIn = false.obs;
  final RxString accessToken = ''.obs;
  final RxString userId = ''.obs;
  final RxString pageId = ''.obs;
  final RxString businessAccountId = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    try {
      isLoading.value = true;
      final token = await _storage.read(key: AppConstants.accessTokenKey);
      final userId = await _storage.read(key: AppConstants.userIdKey);
      final pageId = await _storage.read(key: AppConstants.pageIdKey);
      final businessId = await _storage.read(key: AppConstants.businessAccountIdKey);

      if (token != null && userId != null && pageId != null && businessId != null) {
        accessToken.value = token;
        this.userId.value = userId;
        this.pageId.value = pageId;
        businessAccountId.value = businessId;
        isLoggedIn.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to check existing session');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    try {
      isLoading.value = true;

      final authUrl = Uri.parse(
          '${AppConstants.instagramOAuthUrl}?'
              'client_id=${AppConstants.instagramAppId}&'
              'redirect_uri=${Uri.encodeComponent(AppConstants.redirectUri)}&'
              'scope=${Uri.encodeComponent(AppConstants.scope)}&'
              'response_type=code&'
              'state=insta_auth'
      );

      final deepLinkHandler = Get.find<DeepLinkHandler>();
      await deepLinkHandler.launchDeepLink(authUrl);
    } catch (e) {
      Get.snackbar('Error', 'Failed to start login process: ${e.toString()}');
      isLoading.value = false;
    }
  }

  Future<void> handleDeepLinkAuth(String code) async {
    try {
      isLoading.value = true;

      // Exchange code for access token
      final tokenResponse = await _apiService.exchangeCodeForToken(
        code: code,
        redirectUri: AppConstants.redirectUri,
      );

      // Continue with getting user info and pages
      final userResponse = await _apiService.getMetaUserInfo(tokenResponse['access_token']);
      // final pagesResponse = await _apiService.getUserPages(userResponse['id'], tokenResponse['access_token']);

      // if (pagesResponse['data'] == null || pagesResponse['data'].isEmpty) {
      //   throw Exception('No Facebook pages found for this user');
      // }
      //
      // // Get Instagram Business Account ID
      // final pageId = pagesResponse['data'][0]['id'];
      // final instagramAccountResponse = await _apiService.getInstagramBusinessAccount(
      //     pageId,
      //     tokenResponse['access_token']
      // );

      // if (instagramAccountResponse['instagram_business_account'] == null) {
      //   throw Exception('No Instagram Business Account connected to this page');
      // }
      //
      // // Store all credentials
      // final businessAccountId = instagramAccountResponse['instagram_business_account']['id'];

      await _storage.write(key: AppConstants.accessTokenKey, value: tokenResponse['access_token']);
      await _storage.write(key: AppConstants.userIdKey, value: userResponse['id']);
      // await _storage.write(key: AppConstants.pageIdKey, value: pageId);
      // await _storage.write(key: AppConstants.businessAccountIdKey, value: businessAccountId);

      // Update state
      accessToken.value = tokenResponse['access_token'];
      userId.value = userResponse['id'];
      // this.pageId.value = pageId;
      // businessAccountId.value = businessAccountId;
      isLoggedIn.value = true;

      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete login: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _storage.delete(key: AppConstants.accessTokenKey);
      await _storage.delete(key: AppConstants.userIdKey);
      await _storage.delete(key: AppConstants.pageIdKey);
      await _storage.delete(key: AppConstants.businessAccountIdKey);

      accessToken.value = '';
      userId.value = '';
      pageId.value = '';
      businessAccountId.value = '';
      isLoggedIn.value = false;

      Get.offAll(() => const LoginScreen());
    } finally {
      isLoading.value = false;
    }
  }
}