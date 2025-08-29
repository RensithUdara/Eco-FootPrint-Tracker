import 'package:json_annotation/json_annotation.dart';

part 'achievement_model.g.dart';

enum AchievementCategory {
  transportation,
  food,
  energy,
  shopping,
  community,
  streak,
  milestone
}

@JsonSerializable()
class AchievementModel {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final AchievementCategory category;
  final int pointsRequired;
  final Map<String, dynamic> requirements;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  AchievementModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.category,
    required this.pointsRequired,
    this.requirements = const {},
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) => 
    _$AchievementModelFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementModelToJson(this);

  AchievementModel copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return AchievementModel(
      id: id,
      name: name,
      description: description,
      iconUrl: iconUrl,
      category: category,
      pointsRequired: pointsRequired,
      requirements: requirements,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

@JsonSerializable()
class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int targetValue;
  final String unit;
  final int rewardPoints;
  final List<String> participants;
  final bool isActive;
  final ChallengeType type;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.targetValue,
    required this.unit,
    required this.rewardPoints,
    this.participants = const [],
    this.isActive = true,
    required this.type,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) => 
    _$ChallengeModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeModelToJson(this);

  bool get isExpired => DateTime.now().isAfter(endDate);
  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
}

enum ChallengeType {
  individual,
  community,
  team
}

@JsonSerializable()
class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int points;
  final int rank;
  final double carbonSaved;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.points,
    required this.rank,
    required this.carbonSaved,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => 
    _$LeaderboardEntryFromJson(json);
  Map<String, dynamic> toJson() => _$LeaderboardEntryToJson(this);
}
