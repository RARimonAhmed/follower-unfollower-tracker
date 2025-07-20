class Follower {
  final String id;
  final String username;
  final String profilePictureUrl;

  Follower({
    required this.id,
    required this.username,
    required this.profilePictureUrl,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json['id'],
      username: json['username'],
      profilePictureUrl: json['profile_picture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile_picture': profilePictureUrl,
    };
  }
}