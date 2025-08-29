import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/activity_model.dart';
import '../services/database_service.dart';
import '../services/carbon_calculation_service.dart';

class UserController extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final CarbonCalculationService _carbonService = CarbonCalculationService();
  
  UserModel? _currentUser;
  List<ActivityModel> _userActivities = [];
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  List<ActivityModel> get userActivities => _userActivities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize user session
  Future<void> initializeUser(String userId) async {
    try {
      _setLoading(true);
      _currentUser = await _databaseService.getUserById(userId);
      if (_currentUser != null) {
        await loadUserActivities();
      }
      _setError(null);
    } catch (e) {
      _setError('Failed to initialize user: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create a new user
  Future<UserModel?> createUser({
    required String name,
    required String email,
    String? profileImageUrl,
  }) async {
    try {
      _setLoading(true);
      
      final user = UserModel(
        id: const Uuid().v4(),
        name: name,
        email: email,
        profileImageUrl: profileImageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        preferences: UserPreferences(),
        stats: UserStats(lastActiveDate: DateTime.now()),
      );

      await _databaseService.insertUser(user);
      _currentUser = user;
      _setError(null);
      return user;
    } catch (e) {
      _setError('Failed to create user: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? profileImageUrl,
    UserPreferences? preferences,
  }) async {
    if (_currentUser == null) return;

    try {
      _setLoading(true);
      
      final updatedUser = _currentUser!.copyWith(
        name: name,
        email: email,
        profileImageUrl: profileImageUrl,
        preferences: preferences,
      );

      await _databaseService.updateUser(updatedUser);
      _currentUser = updatedUser;
      _setError(null);
    } catch (e) {
      _setError('Failed to update profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load user activities
  Future<void> loadUserActivities() async {
    if (_currentUser == null) return;

    try {
      _userActivities = await _databaseService.getActivitiesByUserId(_currentUser!.id);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load activities: $e');
    }
  }

  // Add new activity
  Future<void> addActivity(ActivityModel activity) async {
    if (_currentUser == null) return;

    try {
      await _databaseService.insertActivity(activity);
      _userActivities.insert(0, activity);
      
      // Update user stats
      await _updateUserStats(activity);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add activity: $e');
    }
  }

  // Create transportation activity
  Future<void> addTransportationActivity({
    required String transportType,
    required double distance,
    String? vehicleModel,
    int passengers = 1,
    String? fuelType,
  }) async {
    if (_currentUser == null) return;

    final carbonFootprint = _carbonService.calculateTransportationFootprint(
      vehicleType: transportType,
      distanceKm: distance,
      passengers: passengers,
      fuelType: fuelType,
    );

    final greenPoints = _carbonService.calculateGreenPoints(carbonFootprint);

    final activity = TransportationActivity(
      id: const Uuid().v4(),
      userId: _currentUser!.id,
      title: 'Transportation: $transportType',
      description: '${distance.toStringAsFixed(1)} km via $transportType',
      carbonFootprint: carbonFootprint,
      greenPointsEarned: greenPoints,
      timestamp: DateTime.now(),
      transportType: TransportationType.values.firstWhere(
        (e) => e.name.toLowerCase() == transportType.toLowerCase(),
        orElse: () => TransportationType.car,
      ),
      distance: distance,
      vehicleModel: vehicleModel,
      passengers: passengers,
    );

    await addActivity(activity);
  }

  // Create food activity
  Future<void> addFoodActivity({
    required String foodName,
    required double quantity,
    required String foodType,
    bool isLocal = false,
    bool isOrganic = false,
    bool isVegetarian = false,
    bool isVegan = false,
  }) async {
    if (_currentUser == null) return;

    final carbonFootprint = _carbonService.calculateFoodFootprint(
      foodType: foodType,
      quantityGrams: quantity,
      isLocal: isLocal,
      isOrganic: isOrganic,
      isVegetarian: isVegetarian,
    );

    final greenPoints = _carbonService.calculateGreenPoints(carbonFootprint);

    final activity = FoodActivity(
      id: const Uuid().v4(),
      userId: _currentUser!.id,
      title: 'Food: $foodName',
      description: '${quantity.toStringAsFixed(0)}g of $foodName',
      carbonFootprint: carbonFootprint,
      greenPointsEarned: greenPoints,
      timestamp: DateTime.now(),
      foodName: foodName,
      quantity: quantity,
      isLocal: isLocal,
      isOrganic: isOrganic,
      isVegetarian: isVegetarian,
      isVegan: isVegan,
    );

    await addActivity(activity);
  }

  // Create energy activity
  Future<void> addEnergyActivity({
    required String energyType,
    required double consumption,
    required String unit,
    bool isRenewable = false,
  }) async {
    if (_currentUser == null) return;

    final carbonFootprint = _carbonService.calculateEnergyFootprint(
      energyType: energyType,
      consumption: consumption,
      unit: unit,
      isRenewable: isRenewable,
    );

    final greenPoints = _carbonService.calculateGreenPoints(carbonFootprint);

    final activity = EnergyActivity(
      id: const Uuid().v4(),
      userId: _currentUser!.id,
      title: 'Energy: $energyType',
      description: '${consumption.toStringAsFixed(1)} $unit of $energyType',
      carbonFootprint: carbonFootprint,
      greenPointsEarned: greenPoints,
      timestamp: DateTime.now(),
      energyType: energyType,
      consumption: consumption,
      unit: unit,
      isRenewable: isRenewable,
    );

    await addActivity(activity);
  }

  // Update user stats after adding activity
  Future<void> _updateUserStats(ActivityModel activity) async {
    if (_currentUser == null) return;

    final currentStats = _currentUser!.stats;
    final newStats = currentStats.copyWith(
      greenPoints: currentStats.greenPoints + activity.greenPointsEarned,
      totalCarbonSaved: currentStats.totalCarbonSaved + 
          (activity.carbonFootprint < 0 ? -activity.carbonFootprintInKg : 0),
      lastActiveDate: DateTime.now(),
    );

    final updatedUser = _currentUser!.copyWith(stats: newStats);
    await _databaseService.updateUser(updatedUser);
    _currentUser = updatedUser;
  }

  // Get daily carbon footprint
  double getDailyCarbonFootprint([DateTime? date]) {
    final targetDate = date ?? DateTime.now();
    final startOfDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _userActivities
        .where((activity) => 
            activity.timestamp.isAfter(startOfDay) && 
            activity.timestamp.isBefore(endOfDay))
        .fold(0.0, (sum, activity) => sum + activity.carbonFootprint);
  }

  // Get weekly carbon footprint
  double getWeeklyCarbonFootprint([DateTime? date]) {
    final targetDate = date ?? DateTime.now();
    final startOfWeek = targetDate.subtract(Duration(days: targetDate.weekday - 1));
    final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final endOfWeek = startOfWeekDay.add(const Duration(days: 7));

    return _userActivities
        .where((activity) => 
            activity.timestamp.isAfter(startOfWeekDay) && 
            activity.timestamp.isBefore(endOfWeek))
        .fold(0.0, (sum, activity) => sum + activity.carbonFootprint);
  }

  // Get activities by type
  List<ActivityModel> getActivitiesByType(ActivityType type) {
    return _userActivities.where((activity) => activity.type == type).toList();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
