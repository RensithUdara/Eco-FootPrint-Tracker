import 'package:flutter/foundation.dart';
import '../models/business_model.dart';
import '../services/database_service.dart';
import '../services/location_service.dart';

class BusinessController extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final LocationService _locationService = LocationService();
  
  List<BusinessModel> _nearbyBusinesses = [];
  List<BusinessModel> _allBusinesses = [];
  List<RewardModel> _availableRewards = [];
  bool _isLoading = false;
  String? _error;
  double? _userLatitude;
  double? _userLongitude;

  List<BusinessModel> get nearbyBusinesses => _nearbyBusinesses;
  List<BusinessModel> get allBusinesses => _allBusinesses;
  List<RewardModel> get availableRewards => _availableRewards;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load nearby businesses based on user location
  Future<void> loadNearbyBusinesses({double radiusKm = 10.0}) async {
    try {
      _setLoading(true);

      // Get user location
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        _userLatitude = position.latitude;
        _userLongitude = position.longitude;

        _nearbyBusinesses = await _databaseService.getBusinessesNearby(
          position.latitude,
          position.longitude,
          radiusKm: radiusKm,
        );

        // Sort by distance
        _nearbyBusinesses.sort((a, b) => 
          a.distanceFrom(_userLatitude!, _userLongitude!)
              .compareTo(b.distanceFrom(_userLatitude!, _userLongitude!)));
      }

      _setError(null);
    } catch (e) {
      _setError('Failed to load nearby businesses: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load businesses by category
  Future<void> loadBusinessesByCategory(String category) async {
    try {
      _setLoading(true);
      
      // In a real app, this would filter from database
      _allBusinesses = await _databaseService.getBusinessesNearby(
        _userLatitude ?? 0,
        _userLongitude ?? 0,
        radiusKm: 50.0,
      );
      
      _allBusinesses = _allBusinesses
          .where((business) => business.category.toLowerCase() == category.toLowerCase())
          .toList();

      _setError(null);
    } catch (e) {
      _setError('Failed to load businesses by category: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search businesses by name or description
  List<BusinessModel> searchBusinesses(String query) {
    if (query.isEmpty) return _nearbyBusinesses;

    final lowerQuery = query.toLowerCase();
    return _nearbyBusinesses.where((business) =>
        business.name.toLowerCase().contains(lowerQuery) ||
        business.description.toLowerCase().contains(lowerQuery) ||
        business.category.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // Check if user can check in to a business
  bool canCheckIn(BusinessModel business) {
    if (_userLatitude == null || _userLongitude == null) return false;

    return _locationService.isWithinBusinessRadius(
      _userLatitude!,
      _userLongitude!,
      business.latitude,
      business.longitude,
      radiusMeters: 100.0,
    );
  }

  // Check in to a business
  Future<Map<String, dynamic>?> checkInToBusiness(
    String businessId,
    String userId,
  ) async {
    try {
      final business = _nearbyBusinesses.firstWhere((b) => b.id == businessId);
      
      if (!canCheckIn(business)) {
        throw Exception('You must be within 100m of the business to check in');
      }

      // Calculate points earned
      int basePoints = 10; // Base check-in points
      int multiplier = business.pointsMultiplier['visit'] ?? 1;
      int pointsEarned = basePoints * multiplier;

      // In a real app, you'd save the check-in to the database
      return {
        'success': true,
        'business': business,
        'pointsEarned': pointsEarned,
        'message': 'Successfully checked in to ${business.name}!',
      };
    } catch (e) {
      _setError('Check-in failed: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Get available rewards for a business
  Future<List<RewardModel>> getBusinessRewards(String businessId) async {
    try {
      // In a real app, this would query the database
      // For now, return sample rewards
      return [
        RewardModel(
          id: 'reward_1',
          businessId: businessId,
          title: '10% Off Next Purchase',
          description: 'Get 10% off your next eco-friendly purchase',
          pointsCost: 100,
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        ),
        RewardModel(
          id: 'reward_2',
          businessId: businessId,
          title: 'Free Coffee',
          description: 'Get a free organic coffee with any pastry',
          pointsCost: 150,
          expiresAt: DateTime.now().add(const Duration(days: 14)),
        ),
      ];
    } catch (e) {
      _setError('Failed to load rewards: $e');
      return [];
    }
  }

  // Redeem a reward
  Future<bool> redeemReward(
    String rewardId,
    String userId,
    int userPoints,
  ) async {
    try {
      // Find the reward
      final reward = _availableRewards.firstWhere((r) => r.id == rewardId);
      
      // Check if user has enough points
      if (userPoints < reward.pointsCost) {
        throw Exception('Insufficient points to redeem this reward');
      }

      // Check if reward is still available
      if (!reward.isAvailable) {
        throw Exception('This reward is no longer available');
      }

      // In a real app, you'd:
      // 1. Deduct points from user account
      // 2. Create redemption record
      // 3. Generate QR code or coupon
      
      return true;
    } catch (e) {
      _setError('Failed to redeem reward: $e');
      return false;
    }
  }

  // Get businesses by sustainability features
  List<BusinessModel> getBusinessesByFeature(String feature) {
    return _nearbyBusinesses.where((business) =>
        business.sustainabilityFeatures.contains(feature)
    ).toList();
  }

  // Get top-rated green businesses
  List<BusinessModel> getTopRatedBusinesses({int limit = 5}) {
    final sortedBusinesses = List<BusinessModel>.from(_nearbyBusinesses);
    sortedBusinesses.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedBusinesses.take(limit).toList();
  }

  // Get business categories
  List<String> getBusinessCategories() {
    final categories = _nearbyBusinesses
        .map((business) => business.category)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  // Get distance to business
  String getDistanceText(BusinessModel business) {
    if (_userLatitude == null || _userLongitude == null) {
      return 'Distance unknown';
    }

    final distance = business.distanceFrom(_userLatitude!, _userLongitude!);
    if (distance < 1.0) {
      return '${(distance * 1000).round()}m away';
    } else {
      return '${distance.toStringAsFixed(1)}km away';
    }
  }

  // Check if business is currently open
  bool isBusinessOpen(BusinessModel business) {
    return business.hours.isOpenNow();
  }

  // Get business hours for today
  String getTodayHours(BusinessModel business) {
    final now = DateTime.now();
    final dayOfWeek = _getDayOfWeek(now.weekday);
    return business.hours.hours[dayOfWeek] ?? 'Hours unavailable';
  }

  String _getDayOfWeek(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
