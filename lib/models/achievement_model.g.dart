// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AchievementModel _$AchievementModelFromJson(Map<String, dynamic> json) =>
    AchievementModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      category: $enumDecode(_$AchievementCategoryEnumMap, json['category']),
      pointsRequired: (json['pointsRequired'] as num).toInt(),
      requirements: json['requirements'] as Map<String, dynamic>? ?? const {},
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
    );

Map<String, dynamic> _$AchievementModelToJson(AchievementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'category': _$AchievementCategoryEnumMap[instance.category]!,
      'pointsRequired': instance.pointsRequired,
      'requirements': instance.requirements,
      'isUnlocked': instance.isUnlocked,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
    };

const _$AchievementCategoryEnumMap = {
  AchievementCategory.transportation: 'transportation',
  AchievementCategory.food: 'food',
  AchievementCategory.energy: 'energy',
  AchievementCategory.shopping: 'shopping',
  AchievementCategory.community: 'community',
  AchievementCategory.streak: 'streak',
  AchievementCategory.milestone: 'milestone',
};

ChallengeModel _$ChallengeModelFromJson(Map<String, dynamic> json) =>
    ChallengeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      targetValue: (json['targetValue'] as num).toInt(),
      unit: json['unit'] as String,
      rewardPoints: (json['rewardPoints'] as num).toInt(),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      type: $enumDecode(_$ChallengeTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ChallengeModelToJson(ChallengeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'targetValue': instance.targetValue,
      'unit': instance.unit,
      'rewardPoints': instance.rewardPoints,
      'participants': instance.participants,
      'isActive': instance.isActive,
      'type': _$ChallengeTypeEnumMap[instance.type]!,
    };

const _$ChallengeTypeEnumMap = {
  ChallengeType.individual: 'individual',
  ChallengeType.community: 'community',
  ChallengeType.team: 'team',
};

LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) =>
    LeaderboardEntry(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      points: (json['points'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
      carbonSaved: (json['carbonSaved'] as num).toDouble(),
    );

Map<String, dynamic> _$LeaderboardEntryToJson(LeaderboardEntry instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'avatarUrl': instance.avatarUrl,
      'points': instance.points,
      'rank': instance.rank,
      'carbonSaved': instance.carbonSaved,
    };
