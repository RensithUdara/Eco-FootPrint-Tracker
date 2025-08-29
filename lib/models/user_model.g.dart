// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      preferences:
          UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profileImageUrl': instance.profileImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'preferences': instance.preferences,
      'stats': instance.stats,
    };

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      units: json['units'] as String? ?? 'metric',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      locationTrackingEnabled:
          json['locationTrackingEnabled'] as bool? ?? false,
      dailyGoal: (json['dailyGoal'] as num?)?.toInt() ?? 1000,
      dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'units': instance.units,
      'notificationsEnabled': instance.notificationsEnabled,
      'locationTrackingEnabled': instance.locationTrackingEnabled,
      'dailyGoal': instance.dailyGoal,
      'dietaryRestrictions': instance.dietaryRestrictions,
    };

UserStats _$UserStatsFromJson(Map<String, dynamic> json) => UserStats(
      greenPoints: (json['greenPoints'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      totalCarbonSaved: (json['totalCarbonSaved'] as num?)?.toDouble() ?? 0.0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      achievementsUnlocked:
          (json['achievementsUnlocked'] as num?)?.toInt() ?? 0,
      lastActiveDate: DateTime.parse(json['lastActiveDate'] as String),
    );

Map<String, dynamic> _$UserStatsToJson(UserStats instance) => <String, dynamic>{
      'greenPoints': instance.greenPoints,
      'level': instance.level,
      'totalCarbonSaved': instance.totalCarbonSaved,
      'streakDays': instance.streakDays,
      'achievementsUnlocked': instance.achievementsUnlocked,
      'lastActiveDate': instance.lastActiveDate.toIso8601String(),
    };
