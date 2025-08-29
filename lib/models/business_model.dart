import 'package:json_annotation/json_annotation.dart';
import 'dart:math' show atan2, cos, sin, sqrt, pi;

part 'business_model.g.dart';

@JsonSerializable()
class BusinessModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String category;
  final List<String> certifications;
  final double rating;
  final int reviewCount;
  final String? imageUrl;
  final String? websiteUrl;
  final String? phoneNumber;
  final BusinessHours hours;
  final List<String> sustainabilityFeatures;
  final Map<String, int> pointsMultiplier;

  BusinessModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.certifications = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.imageUrl,
    this.websiteUrl,
    this.phoneNumber,
    required this.hours,
    this.sustainabilityFeatures = const [],
    this.pointsMultiplier = const {},
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) => 
    _$BusinessModelFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessModelToJson(this);

  double distanceFrom(double userLat, double userLng) {
    // Haversine formula for calculating distance between two points
    const double earthRadius = 6371; // Earth radius in km
    
    double dLat = _degreesToRadians(latitude - userLat);
    double dLng = _degreesToRadians(longitude - userLng);
    
    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degreesToRadians(userLat)) *
            cos(_degreesToRadians(latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}

@JsonSerializable()
class BusinessHours {
  final Map<String, String> hours; // day of week -> "09:00-17:00"
  final bool isOpen24Hours;
  final List<String> closedDays;

  BusinessHours({
    this.hours = const {},
    this.isOpen24Hours = false,
    this.closedDays = const [],
  });

  factory BusinessHours.fromJson(Map<String, dynamic> json) => 
    _$BusinessHoursFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessHoursToJson(this);

  bool isOpenNow() {
    if (isOpen24Hours) return true;
    
    final now = DateTime.now();
    final dayOfWeek = _getDayOfWeek(now.weekday);
    
    if (closedDays.contains(dayOfWeek)) return false;
    
    final todayHours = hours[dayOfWeek];
    if (todayHours == null) return false;
    
    final hoursParts = todayHours.split('-');
    if (hoursParts.length != 2) return false;
    
    final openTime = _parseTime(hoursParts[0]);
    final closeTime = _parseTime(hoursParts[1]);
    final currentTime = now.hour * 60 + now.minute;
    
    return currentTime >= openTime && currentTime <= closeTime;
  }

  String _getDayOfWeek(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
  }

  int _parseTime(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}

@JsonSerializable()
class RewardModel {
  final String id;
  final String businessId;
  final String title;
  final String description;
  final int pointsCost;
  final String? imageUrl;
  final DateTime expiresAt;
  final bool isActive;
  final int maxRedemptions;
  final int currentRedemptions;

  RewardModel({
    required this.id,
    required this.businessId,
    required this.title,
    required this.description,
    required this.pointsCost,
    this.imageUrl,
    required this.expiresAt,
    this.isActive = true,
    this.maxRedemptions = -1, // -1 means unlimited
    this.currentRedemptions = 0,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) => 
    _$RewardModelFromJson(json);
  Map<String, dynamic> toJson() => _$RewardModelToJson(this);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isAvailable => 
    isActive && 
    !isExpired && 
    (maxRedemptions == -1 || currentRedemptions < maxRedemptions);
}


