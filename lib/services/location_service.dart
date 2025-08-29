import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _lastKnownPosition;

  Position? get lastKnownPosition => _lastKnownPosition;

  // Request location permissions
  Future<bool> requestLocationPermission() async {
    try {
      final permission = await Permission.location.request();
      return permission == PermissionStatus.granted;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }

  // Check if location services are enabled and permissions are granted
  Future<bool> isLocationAvailable() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return true;
    } catch (e) {
      print('Error checking location availability: $e');
      return false;
    }
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      if (!await isLocationAvailable()) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      _lastKnownPosition = position;
      return position;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  // Get location with lower accuracy for battery efficiency
  Future<Position?> getCurrentLocationLowAccuracy() async {
    try {
      if (!await isLocationAvailable()) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 5),
      );

      _lastKnownPosition = position;
      return position;
    } catch (e) {
      print('Error getting low accuracy location: $e');
      return null;
    }
  }

  // Calculate distance between two points
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
          startLatitude,
          startLongitude,
          endLatitude,
          endLongitude,
        ) /
        1000; // Convert meters to kilometers
  }

  // Start location tracking for transportation detection
  Stream<Position>? startLocationTracking() {
    try {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 50, // Update every 50 meters
      );

      return Geolocator.getPositionStream(locationSettings: locationSettings);
    } catch (e) {
      print('Error starting location tracking: $e');
      return null;
    }
  }

  // Detect if user is moving (for automatic transportation detection)
  bool isUserMoving(Position currentPosition, Position previousPosition) {
    // Calculate speed in km/h
    double distance = calculateDistance(
      previousPosition.latitude,
      previousPosition.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    int timeDifference = currentPosition.timestamp
        .difference(previousPosition.timestamp)
        .inSeconds;

    if (timeDifference == 0) return false;

    double speedKmh = (distance / timeDifference) * 3600;

    // Consider user moving if speed > 5 km/h
    return speedKmh > 5.0;
  }

  // Estimate transportation mode based on speed
  String estimateTransportationMode(double speedKmh) {
    if (speedKmh < 5) {
      return 'stationary';
    } else if (speedKmh < 10) {
      return 'walking';
    } else if (speedKmh < 25) {
      return 'biking';
    } else if (speedKmh < 60) {
      return 'car_city';
    } else if (speedKmh < 120) {
      return 'car_highway';
    } else {
      return 'plane';
    }
  }

  // Get address from coordinates (simplified - would need geocoding package)
  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      // This would require the geocoding package
      // For now, return a formatted coordinate string
      return 'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  // Check if location is within a business area (for check-ins)
  bool isWithinBusinessRadius(
      double userLat, double userLng, double businessLat, double businessLng,
      {double radiusMeters = 100.0}) {
    double distance = Geolocator.distanceBetween(
      userLat,
      userLng,
      businessLat,
      businessLng,
    );

    return distance <= radiusMeters;
  }

  // Open device location settings
  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      print('Error opening location settings: $e');
    }
  }

  // Open app settings for location permission
  Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
    } catch (e) {
      print('Error opening app settings: $e');
    }
  }
}
