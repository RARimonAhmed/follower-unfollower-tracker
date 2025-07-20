import 'package:get/get.dart';
import 'package:instagram_clone/api_service.dart';
import 'package:instagram_clone/auth_controller.dart';
import 'package:instagram_clone/profile_model.dart';

class ProfileController extends GetxController {
  final Rx<BusinessProfile?> profile = Rx<BusinessProfile?>(null);
  final RxBool isLoading = false.obs;
  final ApiService _apiService = Get.find();
  final AuthController _authController = Get.find();

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final profileData = await _apiService.getBusinessProfile(
        _authController.businessAccountId.value,
        _authController.accessToken.value,
      );
      profile.value = BusinessProfile.fromJson(profileData);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getInsights() async {
    try {
      return await _apiService.getFollowersList(
        _authController.businessAccountId.value,
        _authController.accessToken.value,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load insights: ${e.toString()}');
      rethrow;
    }
  }
}