import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/api_service.dart';
import 'package:instagram_clone/app_constants.dart';
import 'package:instagram_clone/home_screen.dart';
import 'package:instagram_clone/login_screen.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class AuthController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final ApiService _apiService = Get.find();

  // Reactive state
  final RxBool isLoggedIn = false.obs;
  final RxString accessToken = ''.obs;
  final RxString userId = ''.obs;
  final RxString pageId = ''.obs;
  final RxString businessAccountId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
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
  }

  Future<void> login() async {
    try {
      // Use the working Instagram OAuth URL
      final authUrl = Uri.parse(
          '${AppConstants.instagramOAuthUrl}?'
              'force_reauth=true&'
              'client_id=${AppConstants.instagramAppId}&'
              'redirect_uri=${AppConstants.redirectUri}&'
              'response_type=code&'
              'scope=${AppConstants.scope}'
      );

      // Use FlutterWebAuth2 for better OAuth handling
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: Uri.parse(AppConstants.redirectUri).scheme,
      );

      // Extract the authorization code from the redirect URL
      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) throw Exception('Authorization failed');

      // Exchange code for access token
      final tokenResponse = await _apiService.exchangeCodeForToken(
        code: code,
        redirectUri: AppConstants.redirectUri,
      );

      // Continue with getting user info and pages
      final userResponse = await _apiService.getMetaUserInfo(tokenResponse['access_token']);
      final pagesResponse = await _apiService.getUserPages(userResponse['id'], tokenResponse['access_token']);

      if (pagesResponse['data'] == null || pagesResponse['data'].isEmpty) {
        throw Exception('No Facebook pages found for this user');
      }

      // Get Instagram Business Account ID
      final pageId = pagesResponse['data'][0]['id'];
      final instagramAccountResponse = await _apiService.getInstagramBusinessAccount(pageId, tokenResponse['access_token']);

      if (instagramAccountResponse['instagram_business_account'] == null) {
        throw Exception('No Instagram Business Account connected to this page');
      }

      // Store all credentials
      final businessAccountId = instagramAccountResponse['instagram_business_account']['id'];

      await _storage.write(key: AppConstants.accessTokenKey, value: tokenResponse['access_token']);
      await _storage.write(key: AppConstants.userIdKey, value: userResponse['id']);
      await _storage.write(key: AppConstants.pageIdKey, value: pageId);
      await _storage.write(key: AppConstants.businessAccountIdKey, value: businessAccountId);

      // Update state
      accessToken.value = tokenResponse['access_token'];
      userId.value = userResponse['id'];
      pageId.value = pageId;
      businessAccountId.value = businessAccountId;
      isLoggedIn.value = true;

      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete login: ${e.toString()}');
      print("Login error is: ${e.toString()}");
    }
  }

  Future<void> logout() async {
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
  }
}