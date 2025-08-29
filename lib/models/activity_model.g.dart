// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      carbonFootprint: (json['carbonFootprint'] as num).toDouble(),
      greenPointsEarned: (json['greenPointsEarned'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'carbonFootprint': instance.carbonFootprint,
      'greenPointsEarned': instance.greenPointsEarned,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$ActivityTypeEnumMap = {
  ActivityType.transportation: 'transportation',
  ActivityType.food: 'food',
  ActivityType.energy: 'energy',
  ActivityType.shopping: 'shopping',
  ActivityType.other: 'other',
};

TransportationActivity _$TransportationActivityFromJson(
        Map<String, dynamic> json) =>
    TransportationActivity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      carbonFootprint: (json['carbonFootprint'] as num).toDouble(),
      greenPointsEarned: (json['greenPointsEarned'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      transportType:
          $enumDecode(_$TransportationTypeEnumMap, json['transportType']),
      distance: (json['distance'] as num).toDouble(),
      vehicleModel: json['vehicleModel'] as String?,
      passengers: (json['passengers'] as num?)?.toInt() ?? 1,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$TransportationActivityToJson(
        TransportationActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'carbonFootprint': instance.carbonFootprint,
      'greenPointsEarned': instance.greenPointsEarned,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
      'transportType': _$TransportationTypeEnumMap[instance.transportType]!,
      'distance': instance.distance,
      'vehicleModel': instance.vehicleModel,
      'passengers': instance.passengers,
    };

const _$TransportationTypeEnumMap = {
  TransportationType.car: 'car',
  TransportationType.bus: 'bus',
  TransportationType.train: 'train',
  TransportationType.bike: 'bike',
  TransportationType.walk: 'walk',
  TransportationType.plane: 'plane',
  TransportationType.motorcycle: 'motorcycle',
  TransportationType.electricCar: 'electricCar',
  TransportationType.hybrid: 'hybrid',
};

FoodActivity _$FoodActivityFromJson(Map<String, dynamic> json) => FoodActivity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      carbonFootprint: (json['carbonFootprint'] as num).toDouble(),
      greenPointsEarned: (json['greenPointsEarned'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      foodName: json['foodName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      isLocal: json['isLocal'] as bool? ?? false,
      isOrganic: json['isOrganic'] as bool? ?? false,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$FoodActivityToJson(FoodActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'carbonFootprint': instance.carbonFootprint,
      'greenPointsEarned': instance.greenPointsEarned,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
      'foodName': instance.foodName,
      'quantity': instance.quantity,
      'isLocal': instance.isLocal,
      'isOrganic': instance.isOrganic,
      'isVegetarian': instance.isVegetarian,
      'isVegan': instance.isVegan,
    };

EnergyActivity _$EnergyActivityFromJson(Map<String, dynamic> json) =>
    EnergyActivity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      carbonFootprint: (json['carbonFootprint'] as num).toDouble(),
      greenPointsEarned: (json['greenPointsEarned'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      energyType: json['energyType'] as String,
      consumption: (json['consumption'] as num).toDouble(),
      unit: json['unit'] as String,
      isRenewable: json['isRenewable'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$EnergyActivityToJson(EnergyActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'carbonFootprint': instance.carbonFootprint,
      'greenPointsEarned': instance.greenPointsEarned,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
      'energyType': instance.energyType,
      'consumption': instance.consumption,
      'unit': instance.unit,
      'isRenewable': instance.isRenewable,
    };
