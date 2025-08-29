// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessModel _$BusinessModelFromJson(Map<String, dynamic> json) =>
    BusinessModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      category: json['category'] as String,
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      hours: BusinessHours.fromJson(json['hours'] as Map<String, dynamic>),
      sustainabilityFeatures: (json['sustainabilityFeatures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pointsMultiplier:
          (json['pointsMultiplier'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
    );

Map<String, dynamic> _$BusinessModelToJson(BusinessModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'category': instance.category,
      'certifications': instance.certifications,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'imageUrl': instance.imageUrl,
      'websiteUrl': instance.websiteUrl,
      'phoneNumber': instance.phoneNumber,
      'hours': instance.hours,
      'sustainabilityFeatures': instance.sustainabilityFeatures,
      'pointsMultiplier': instance.pointsMultiplier,
    };

BusinessHours _$BusinessHoursFromJson(Map<String, dynamic> json) =>
    BusinessHours(
      hours: (json['hours'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      isOpen24Hours: json['isOpen24Hours'] as bool? ?? false,
      closedDays: (json['closedDays'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BusinessHoursToJson(BusinessHours instance) =>
    <String, dynamic>{
      'hours': instance.hours,
      'isOpen24Hours': instance.isOpen24Hours,
      'closedDays': instance.closedDays,
    };

RewardModel _$RewardModelFromJson(Map<String, dynamic> json) => RewardModel(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      pointsCost: (json['pointsCost'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      maxRedemptions: (json['maxRedemptions'] as num?)?.toInt() ?? -1,
      currentRedemptions: (json['currentRedemptions'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RewardModelToJson(RewardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'title': instance.title,
      'description': instance.description,
      'pointsCost': instance.pointsCost,
      'imageUrl': instance.imageUrl,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'isActive': instance.isActive,
      'maxRedemptions': instance.maxRedemptions,
      'currentRedemptions': instance.currentRedemptions,
    };
