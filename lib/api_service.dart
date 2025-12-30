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

  Future<Map<String, dynamic>> getFollowersList(String usernameOrUrl) async {
    try {
      final headers = {
        'X-RapidAPI-Key': AppConstants.rapidApiKey,
        'X-RapidAPI-Host': AppConstants.rapidApiHost,
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final body = {
        'username_or_url': usernameOrUrl,
        'data': 'followers',
        // Optional parameters from your screenshot
        // 'amount': '50', // Default is 50
        // 'start_from': '0', // Start from first follower
      };

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.followersEndpoint}'),
        headers: headers,
        body: body,
      );

      print("API Request:");
      print("URL: ${AppConstants.baseUrl}${AppConstants.followersEndpoint}");
      print("Headers: $headers");
      print("Body: $body");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch followers. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch followers: $e');
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