class BusinessProfile {
  final String id;
  final String username;
  final String? name;
  final String? biography;
  final String? website;
  final int followersCount;
  final int followsCount;
  final int mediaCount;
  final String profilePictureUrl;
  final String? igId;

  BusinessProfile({
    required this.id,
    required this.username,
    this.name,
    this.biography,
    this.website,
    required this.followersCount,
    required this.followsCount,
    required this.mediaCount,
    required this.profilePictureUrl,
    this.igId,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      biography: json['biography'],
      website: json['website'],
      followersCount: json['followers_count'] ?? 0,
      followsCount: json['follows_count'] ?? 0,
      mediaCount: json['media_count'] ?? 0,
      profilePictureUrl: json['profile_picture_url'] ?? '',
      igId: json['ig_id'],
    );
  }
}