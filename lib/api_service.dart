import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone/app_constants.dart';

class ApiService extends GetxService {

  // Add this to your ApiService class
  Future<Map<String, dynamic>> exchangeCodeForToken({
    required String code,
    required String redirectUri,
  }) async {
    final response = await http.post(
      Uri.parse(AppConstants.instagramTokenUrl),
      body: {
        'client_id': AppConstants.instagramAppId,
        'client_secret': AppConstants.instagramAppSecret,
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUri,
        'code': code,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to exchange code for token: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getMetaUserInfo(String accessToken) async {
    final response = await http.get(
      Uri.parse('${AppConstants.instagramGraphUrl}/me?access_token=$accessToken'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user info: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getUserPages(String userId, String accessToken) async {
    final response = await http.get(
      Uri.parse('${AppConstants.instagramGraphUrl}/$userId/accounts?access_token=$accessToken'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user pages: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getInstagramBusinessAccount(String pageId, String accessToken) async {
    final response = await http.get(
      Uri.parse('${AppConstants.instagramGraphUrl}/$pageId?fields=instagram_business_account&access_token=$accessToken'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Response body is ${response.body}");
      throw Exception('Failed to fetch Instagram business account: ${response.body}');
    }
  }

  // Add this method to your ApiService class
  Future<Map<String, dynamic>> getUserProfile(String userId, String accessToken) async {
    print("User id is $userId");
    final response = await http.get(
      Uri.parse("${AppConstants.instagramGraphUrl}/$userId?fields=name,username,profile_picture_url,followers_count,follows_count,media_count,biography,website&access_token=$accessToken",
      ),
    );

    print("Url is ${AppConstants.instagramGraphUrl}/$userId?fields=name,username,profile_picture_url,followers_count,follows_count,media_count,biography,website&access_token=$accessToken");
    print("Response body is ${response.body.toString()}");
    print("Response status code is ${response.statusCode.toString()}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user profile: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getMedia(String businessAccountId, String accessToken, {int limit = 10}) async {
    final response = await http.get(
      Uri.parse('${AppConstants.instagramGraphUrl}/$businessAccountId/media?fields=id,caption,comments_count,like_count,media_type,media_url,permalink,thumbnail_url,timestamp,username&limit=$limit&access_token=$accessToken'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch media: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getFollowersList(String businessAccountId, String accessToken) async {
    try {
      // Get basic follower count
      final countResponse = await http.get(
        Uri.parse(
          '${AppConstants.instagramGraphUrl}/$businessAccountId/insights?metric=follower_count&period=lifetime&access_token=$accessToken',
        ),
      );

      // Get demographics
      final demoResponse = await http.get(
        Uri.parse(
          '${AppConstants.instagramGraphUrl}/$businessAccountId/insights?metric=follower_count,profile_views&period=lifetime&access_token=$accessToken',
        ),
      );

      print("Url is ${AppConstants.instagramGraphUrl}/$businessAccountId/insights?metric=follower_count,profile_views&period=lifetime&access_token=$accessToken");
      print("Response body is ${demoResponse.body.toString()}");
      print("Response status code is ${demoResponse.statusCode.toString()}");

      if (countResponse.statusCode == 200 && demoResponse.statusCode == 200) {
        return {
          'count': json.decode(countResponse.body),
          'demographics': json.decode(demoResponse.body),
        };
      } else {
        throw Exception('Failed to get complete insights');
      }
    } catch (e) {
      throw Exception('Insights request failed: $e');
    }
  }

  Future<bool> postComment(String mediaId, String text, String accessToken) async {
    final response = await http.post(
      Uri.parse('${AppConstants.instagramGraphUrl}/$mediaId/comments'),
      body: {
        'message': text,
        'access_token': accessToken,
      },
    );

    return response.statusCode == 200;
  }

  Future<bool> unfollowUser(String userId, String accessToken) async {
    // This requires special permissions and review from Meta
    final response = await http.delete(
      Uri.parse('${AppConstants.instagramGraphUrl}/$userId/followers?access_token=$accessToken'),
    );

    return response.statusCode == 200;
  }
}