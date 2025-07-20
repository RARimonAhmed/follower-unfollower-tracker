import 'package:get/get.dart';
import 'package:instagram_clone/api_service.dart';
import 'package:instagram_clone/auth_controller.dart';
import 'package:instagram_clone/follower_insight_model.dart';
import 'package:instagram_clone/storage_service.dart';

class FollowerController extends GetxController {
  final RxList<FollowerInsight> insights = <FollowerInsight>[].obs;
  final RxInt totalFollowers = 0.obs;
  final RxBool isLoading = false.obs;
  final ApiService _apiService = Get.find();
  final StorageService _storage = Get.find();
  final AuthController _auth = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchFollowerInsights();
  }

  Future<void> fetchFollowerInsights() async {
    try {
      isLoading.value = true;
      insights.clear();

      // Get insights from API
      final response = await _apiService.getFollowersList(
        _auth.businessAccountId.value,
        _auth.accessToken.value,
      );

      // Process insights
      final followerCount = response['data']?.firstWhere(
            (metric) => metric['name'] == 'follower_count',
      )['values'][0]['value'] ?? 0;

      totalFollowers.value = followerCount;

      // Process demographic data
      final genderAgeData = response['data']?.firstWhere(
            (metric) => metric['name'] == 'audience_gender_age',
      )['values'][0]['value'];

      final insightsList = _processDemographicData(genderAgeData);
      insights.assignAll(insightsList);

      // Store for offline use
      await _storage.saveFollowerInsights(insightsList);

    } catch (e) {
      Get.snackbar('Error', 'Failed to load follower insights: ${e.toString()}');

      // Try to load from cache if API fails
      final cachedInsights = await _storage.getFollowerInsights();
      if (cachedInsights.isNotEmpty) {
        insights.assignAll(cachedInsights);
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<FollowerInsight> _processDemographicData(Map<String, dynamic> data) {
    final List<FollowerInsight> results = [];

    data.forEach((key, value) {
      final parts = key.split('.');
      if (parts.length == 2) {
        results.add(FollowerInsight(
          gender: parts[0],
          ageRange: parts[1],
          count: value,
        ));
      }
    });

    return results;
  }
}