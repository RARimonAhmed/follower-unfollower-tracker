import 'package:get/get.dart';
import 'package:instagram_clone/api_service.dart';
import 'package:instagram_clone/app_constants.dart';
import 'package:instagram_clone/auth_controller.dart';
import 'package:instagram_clone/follower_insight_model.dart';
import 'package:instagram_clone/follower_model.dart';
import 'package:instagram_clone/storage_service.dart';

class FollowerController extends GetxController {
  final RxList<Follower> followers = <Follower>[].obs;
  final RxString nextPageCursor = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMoreFollowers = true.obs;
  final ApiService _apiService = Get.find();
  final StorageService _storage = Get.find();
  final AuthController _auth = Get.find();
  final String targetUsernameOrUrl = 'https://www.instagram.com/${AppConstants.userName}';

  @override
  void onInit() {
    super.onInit();
    fetchFollowers();
  }

  Future<void> fetchFollowers() async {
    try {
      isLoading.value = true;
      followers.clear();

      final response = await _apiService.getFollowersList(targetUsernameOrUrl);

      // Debug print
      print("API Response: $response");

      if (response['users'] != null) {
        final newFollowers = (response['users'] as List)
            .map((user) => Follower.fromJson(user))
            .toList();

        followers.assignAll(newFollowers);
      } else if (response['error'] != null) {
        Get.snackbar('Error', response['error']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load followers: ${e.toString()}');
      print('Error details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshFollowers() async {
    await fetchFollowers();
  }
}