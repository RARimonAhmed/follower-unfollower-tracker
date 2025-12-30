class Follower {
  final String id;
  final String username;
  final String fullName;
  final String profilePictureUrl;
  final bool isVerified;
  final bool isPrivate;
  final int? latestReelMedia;

  Follower({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profilePictureUrl,
    required this.isVerified,
    required this.isPrivate,
    this.latestReelMedia,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json['pk'].toString(),
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      profilePictureUrl: json['profile_pic_url'] ?? '',
      isVerified: json['is_verified'] ?? false,
      isPrivate: json['is_private'] ?? false,
      latestReelMedia: json['latest_reel_media'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pk': id,
      'username': username,
      'full_name': fullName,
      'profile_pic_url': profilePictureUrl,
      'is_verified': isVerified,
      'is_private': isPrivate,
      'latest_reel_media': latestReelMedia,
    };
  }
}