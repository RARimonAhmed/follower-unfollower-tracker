class AppConstants {
  static const String appName = 'instagram_clone';

  // Meta App Credentials
  static const String appId = '1199077608654806';
  static const String appSecret = '062314b9fff6ac9bb94ef16fd229d9d4';

  // Instagram App Credentials
  static const String instagramAppId = '1473466930346420';
  static const String instagramAppSecret = '91cfcd2e206c9e4d842b4cc78b381c53';

  // OAuth Configuration
  static const String redirectUri = 'https://socialsizzle.herokuapp.com/auth/';
  static const String scope = 'instagram_business_basic,instagram_business_manage_messages,instagram_business_manage_comments,instagram_business_content_publish,instagram_business_manage_insights';

  // API Endpoints
  static const String instagramOAuthUrl = 'https://api.instagram.com/oauth/authorize';
  static const String instagramTokenUrl = 'https://api.instagram.com/oauth/access_token';
  static const String metaAuthUrl = 'https://www.facebook.com/v19.0/dialog/oauth';
  static const String metaTokenUrl = 'https://graph.facebook.com/v19.0/oauth/access_token';
  static const String instagramGraphUrl = 'https://graph.instagram.com';

  // Storage Keys
  static const String accessTokenKey = 'instagram_access_token';
  static const String userIdKey = 'instagram_user_id';
  static const String pageIdKey = 'instagram_page_id';
  static const String businessAccountIdKey = 'instagram_business_account_id';
  static const String followersListKey = 'followers_list_cache';
}


// class AppConstants {
//   static const String appName = 'Instagram Clone';
//
//   // Instagram App Credentials
//   static const String instagramAppId = '1473466930346420';
//   static const String instagramAppSecret = '91cfcd2e206c9e4d842b4cc78b381c53';
//
//   // OAuth Configuration
//   static const String scope = 'instagram_basic,instagram_manage_insights';
//
//   // API Endpoints
//   static const String instagramOAuthUrl = 'https://api.instagram.com/oauth/authorize';
//   static const String instagramTokenUrl = 'https://api.instagram.com/oauth/access_token';
//   static const String instagramGraphUrl = 'https://graph.instagram.com';
//
//   // Storage Keys
//   static const String accessTokenKey = 'instagram_access_token';
//   static const String userIdKey = 'instagram_user_id';
//   static const String pageIdKey = 'instagram_page_id';
//   static const String businessAccountIdKey = 'instagram_business_account_id';
//   static const String tokenExpiryKey = 'instagram_token_expiry';
// }