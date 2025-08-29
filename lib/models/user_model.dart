import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserPreferences preferences;
  final UserStats stats;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.preferences,
    required this.stats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? name,
    String? email,
    String? profileImageUrl,
    UserPreferences? preferences,
    UserStats? stats,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
    );
  }
}

@JsonSerializable()
class UserPreferences {
  final String units; // metric or imperial
  final bool notificationsEnabled;
  final bool locationTrackingEnabled;
  final int dailyGoal; // daily carbon reduction goal in grams
  final List<String> dietaryRestrictions;

  UserPreferences({
    this.units = 'metric',
    this.notificationsEnabled = true,
    this.locationTrackingEnabled = false,
    this.dailyGoal = 1000,
    this.dietaryRestrictions = const [],
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}

@JsonSerializable()
class UserStats {
  final int greenPoints;
  final int level;
  final double totalCarbonSaved; // in kg
  final int streakDays;
  final int achievementsUnlocked;
  final DateTime lastActiveDate;

  UserStats({
    this.greenPoints = 0,
    this.level = 1,
    this.totalCarbonSaved = 0.0,
    this.streakDays = 0,
    this.achievementsUnlocked = 0,
    required this.lastActiveDate,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) => _$UserStatsFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatsToJson(this);

  UserStats copyWith({
    int? greenPoints,
    int? level,
    double? totalCarbonSaved,
    int? streakDays,
    int? achievementsUnlocked,
    DateTime? lastActiveDate,
  }) {
    return UserStats(
      greenPoints: greenPoints ?? this.greenPoints,
      level: level ?? this.level,
      totalCarbonSaved: totalCarbonSaved ?? this.totalCarbonSaved,
      streakDays: streakDays ?? this.streakDays,
      achievementsUnlocked: achievementsUnlocked ?? this.achievementsUnlocked,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}
