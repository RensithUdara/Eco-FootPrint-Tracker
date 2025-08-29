import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

enum ActivityType {
  transportation,
  food,
  energy,
  shopping,
  other
}

enum TransportationType {
  car,
  bus,
  train,
  bike,
  walk,
  plane,
  motorcycle,
  electricCar,
  hybrid
}

@JsonSerializable()
class ActivityModel {
  final String id;
  final String userId;
  final ActivityType type;
  final String title;
  final String description;
  final double carbonFootprint; // in grams of CO2
  final int greenPointsEarned;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.carbonFootprint,
    required this.greenPointsEarned,
    required this.timestamp,
    this.metadata = const {},
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  bool get isEcoFriendly => carbonFootprint < 0;
  
  double get carbonFootprintInKg => carbonFootprint / 1000;
}

@JsonSerializable()
class TransportationActivity extends ActivityModel {
  final TransportationType transportType;
  final double distance; // in km
  final String? vehicleModel;
  final int passengers;

  TransportationActivity({
    required String id,
    required String userId,
    required String title,
    required String description,
    required double carbonFootprint,
    required int greenPointsEarned,
    required DateTime timestamp,
    required this.transportType,
    required this.distance,
    this.vehicleModel,
    this.passengers = 1,
    Map<String, dynamic> metadata = const {},
  }) : super(
    id: id,
    userId: userId,
    type: ActivityType.transportation,
    title: title,
    description: description,
    carbonFootprint: carbonFootprint,
    greenPointsEarned: greenPointsEarned,
    timestamp: timestamp,
    metadata: {
      ...metadata,
      'transportType': transportType.name,
      'distance': distance,
      'vehicleModel': vehicleModel,
      'passengers': passengers,
    },
  );

  factory TransportationActivity.fromJson(Map<String, dynamic> json) => 
    _$TransportationActivityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransportationActivityToJson(this);
}

@JsonSerializable()
class FoodActivity extends ActivityModel {
  final String foodName;
  final double quantity; // in grams
  final bool isLocal;
  final bool isOrganic;
  final bool isVegetarian;
  final bool isVegan;

  FoodActivity({
    required String id,
    required String userId,
    required String title,
    required String description,
    required double carbonFootprint,
    required int greenPointsEarned,
    required DateTime timestamp,
    required this.foodName,
    required this.quantity,
    this.isLocal = false,
    this.isOrganic = false,
    this.isVegetarian = false,
    this.isVegan = false,
    Map<String, dynamic> metadata = const {},
  }) : super(
    id: id,
    userId: userId,
    type: ActivityType.food,
    title: title,
    description: description,
    carbonFootprint: carbonFootprint,
    greenPointsEarned: greenPointsEarned,
    timestamp: timestamp,
    metadata: {
      ...metadata,
      'foodName': foodName,
      'quantity': quantity,
      'isLocal': isLocal,
      'isOrganic': isOrganic,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
    },
  );

  factory FoodActivity.fromJson(Map<String, dynamic> json) => 
    _$FoodActivityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FoodActivityToJson(this);
}

@JsonSerializable()
class EnergyActivity extends ActivityModel {
  final String energyType; // electricity, gas, water
  final double consumption;
  final String unit; // kWh, m³, etc.
  final bool isRenewable;

  EnergyActivity({
    required String id,
    required String userId,
    required String title,
    required String description,
    required double carbonFootprint,
    required int greenPointsEarned,
    required DateTime timestamp,
    required this.energyType,
    required this.consumption,
    required this.unit,
    this.isRenewable = false,
    Map<String, dynamic> metadata = const {},
  }) : super(
    id: id,
    userId: userId,
    type: ActivityType.energy,
    title: title,
    description: description,
    carbonFootprint: carbonFootprint,
    greenPointsEarned: greenPointsEarned,
    timestamp: timestamp,
    metadata: {
      ...metadata,
      'energyType': energyType,
      'consumption': consumption,
      'unit': unit,
      'isRenewable': isRenewable,
    },
  );

  factory EnergyActivity.fromJson(Map<String, dynamic> json) => 
    _$EnergyActivityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EnergyActivityToJson(this);
}
