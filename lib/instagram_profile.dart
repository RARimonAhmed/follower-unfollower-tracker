class InstagramProfile {
  final String id;
  final String username;
  final String accountType;
  final int mediaCount;
  final String profilePictureUrl;

  InstagramProfile({
    required this.id,
    required this.username,
    required this.accountType,
    required this.mediaCount,
    required this.profilePictureUrl,
  });

  factory InstagramProfile.fromJson(Map<String, dynamic> json) {
    return InstagramProfile(
      id: json['id'],
      username: json['username'],
      accountType: json['account_type'],
      mediaCount: json['media_count'],
      profilePictureUrl: json['profile_picture_url'] ?? '',
    );
  }
}