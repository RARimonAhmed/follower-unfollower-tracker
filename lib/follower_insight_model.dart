class FollowerInsight {
  final String gender;
  final String ageRange;
  final int count;

  FollowerInsight({
    required this.gender,
    required this.ageRange,
    required this.count,
  });

  // Gender display name
  String get genderName {
    switch (gender) {
      case 'F':
        return 'Female';
      case 'M':
        return 'Male';
      case 'U':
        return 'Unknown';
      default:
        return gender;
    }
  }

  // Age range display format
  String get formattedAgeRange {
    if (ageRange.contains('-')) {
      return '${ageRange.split('-')[0]}-${ageRange.split('-')[1]} years';
    }
    return '$ageRange years';
  }

  // Instagram-specific demographic label
  String get instagramDemographicLabel {
    return '$genderName, $formattedAgeRange';
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age_range': ageRange,  // Using Instagram's field name convention
      'count': count,
    };
  }

  // Create from JSON
  factory FollowerInsight.fromJson(Map<String, dynamic> json) {
    return FollowerInsight(
      gender: json['gender'] ?? json['gender_code'] ?? 'U',  // Fallback to 'U' (Unknown)
      ageRange: json['age_range'] ?? json['ageRange'] ?? '18-24',  // Default age range
      count: json['count'] ?? json['value'] ?? 0,  // Fallback to 0
    );
  }

  // Helper method for Instagram API response parsing
  static List<FollowerInsight> fromInstagramResponse(Map<String, dynamic> response) {
    final List<FollowerInsight> insights = [];

    try {
      final genderAgeData = response['data']?.firstWhere(
            (metric) => metric['name'] == 'audience_gender_age',
      )['values'][0]['value'];

      genderAgeData?.forEach((key, value) {
        final parts = key.split('.');
        if (parts.length == 2) {
          insights.add(FollowerInsight(
            gender: parts[0],
            ageRange: parts[1],
            count: value,
          ));
        }
      });
    } catch (e) {
      print('Error parsing Instagram response: $e');
    }

    return insights;
  }

  // For equality comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FollowerInsight &&
              runtimeType == other.runtimeType &&
              gender == other.gender &&
              ageRange == other.ageRange &&
              count == other.count;

  @override
  int get hashCode => gender.hashCode ^ ageRange.hashCode ^ count.hashCode;

  @override
  String toString() {
    return 'FollowerInsight{gender: $gender, ageRange: $ageRange, count: $count}';
  }
}