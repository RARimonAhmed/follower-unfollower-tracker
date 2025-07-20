import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/app_constants.dart';
import 'package:instagram_clone/follower_insight_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  final _storage = const FlutterSecureStorage();
  late final SharedPreferences _sharedPrefs;

  Future<StorageService> init() async {
    _sharedPrefs = Get.find<SharedPreferences>();
    return this;
  }

  Future<void> saveFollowerInsights(List<FollowerInsight> insights) async {
    final jsonList = insights.map((insight) => insight.toJson()).toList();
    await _sharedPrefs.setString(
      AppConstants.followersListKey,
      json.encode(jsonList),
    );
  }

  Future<List<FollowerInsight>> getFollowerInsights() async {
    final jsonString = _sharedPrefs.getString(AppConstants.followersListKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => FollowerInsight.fromJson(json)).toList();
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
    await _sharedPrefs.clear();
  }
}