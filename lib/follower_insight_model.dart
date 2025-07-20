class FollowerInsight {
  final String gender; // "F" or "M"
  final String ageRange; // "18-24", "25-34", etc.
  final int count;

  FollowerInsight({
    required this.gender,
    required this.ageRange,
    required this.count,
  });

  String get genderName => gender == 'F' ? 'Female' : 'Male';
}