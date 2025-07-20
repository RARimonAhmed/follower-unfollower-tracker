class BusinessProfile {
  final String? id;
  final String? username;
  final String? name;
  final String? profilePictureUrl;
  final int? followersCount;
  final int? followsCount;
  final int? mediaCount;
  final String? biography;
  final String? website;
  final bool? isUserFollowBusiness;
  final bool? isBusinessFollowUser;

  BusinessProfile({
    this.id,
    this.username,
    this.name,
    this.profilePictureUrl,
    this.followersCount,
    this.followsCount,
    this.mediaCount,
    this.biography,
    this.website,
    this.isUserFollowBusiness,
    this.isBusinessFollowUser,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      profilePictureUrl: json['profile_picture_url'] ?? json['profile_pic'],
      followersCount: json['followers_count'],
      followsCount: json['follows_count'],
      mediaCount: json['media_count'],
      biography: json['biography'],
      website: json['website'],
      isUserFollowBusiness: json['is_user_follow_business'],
      isBusinessFollowUser: json['is_business_follow_user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'profile_picture_url': profilePictureUrl,
      'followers_count': followersCount,
      'follows_count': followsCount,
      'media_count': mediaCount,
      'biography': biography,
      'website': website,
      'is_user_follow_business': isUserFollowBusiness,
      'is_business_follow_user': isBusinessFollowUser,
    };
  }

  // You might want to add a method to check if the profile is empty
  bool get isEmpty =>
      id == null &&
          username == null &&
          name == null &&
          profilePictureUrl == null;

  // And a method to check if the profile is not empty
  bool get isNotEmpty => !isEmpty;
}