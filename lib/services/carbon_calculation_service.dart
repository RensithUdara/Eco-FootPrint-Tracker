class CarbonCalculationService {
  static final CarbonCalculationService _instance = CarbonCalculationService._internal();
  factory CarbonCalculationService() => _instance;
  CarbonCalculationService._internal();

  // Transportation carbon emissions (grams CO2 per km)
  static const Map<String, double> _transportEmissions = {
    'car_gasoline': 120.0,
    'car_diesel': 110.0,
    'car_electric': 50.0,
    'car_hybrid': 80.0,
    'bus': 60.0,
    'train': 35.0,
    'bike': -10.0, // Negative because it saves carbon vs alternatives
    'walk': -15.0,
    'plane': 250.0,
    'motorcycle': 95.0,
  };

  // Food carbon emissions (grams CO2 per 100g)
  static const Map<String, double> _foodEmissions = {
    'beef': 6000.0,
    'lamb': 5000.0,
    'pork': 1200.0,
    'chicken': 800.0,
    'fish': 600.0,
    'eggs': 400.0,
    'dairy_milk': 320.0,
    'cheese': 1100.0,
    'rice': 280.0,
    'wheat': 150.0,
    'vegetables_local': 50.0,
    'vegetables_imported': 150.0,
    'fruits_local': 30.0,
    'fruits_imported': 100.0,
    'legumes': 80.0,
    'nuts': 200.0,
  };

  // Energy carbon emissions (grams CO2 per kWh)
  static const Map<String, double> _energyEmissions = {
    'electricity_grid': 400.0,
    'electricity_solar': 40.0,
    'electricity_wind': 10.0,
    'natural_gas': 200.0,
    'heating_oil': 280.0,
  };

  // Calculate transportation carbon footprint
  double calculateTransportationFootprint({
    required String vehicleType,
    required double distanceKm,
    int passengers = 1,
    String? fuelType,
  }) {
    String key = vehicleType.toLowerCase();
    if (fuelType != null) {
      key = '${vehicleType.toLowerCase()}_${fuelType.toLowerCase()}';
    }

    double emissionPerKm = _transportEmissions[key] ?? _transportEmissions['car_gasoline']!;
    double totalEmission = emissionPerKm * distanceKm;

    // Divide by passengers for carpooling benefit
    if (passengers > 1 && vehicleType != 'bike' && vehicleType != 'walk') {
      totalEmission = totalEmission / passengers;
    }

    return totalEmission;
  }

  // Calculate food carbon footprint
  double calculateFoodFootprint({
    required String foodType,
    required double quantityGrams,
    bool isLocal = false,
    bool isOrganic = false,
    bool isVegetarian = false,
  }) {
    String key = foodType.toLowerCase();
    
    // Adjust for local vs imported
    if (key.contains('vegetables') || key.contains('fruits')) {
      key = isLocal ? '${key}_local' : '${key}_imported';
    }

    double emissionPer100g = _foodEmissions[key] ?? 200.0;
    double totalEmission = (emissionPer100g * quantityGrams) / 100.0;

    // Apply modifiers
    if (isOrganic) {
      totalEmission *= 0.9; // 10% reduction for organic
    }
    
    if (isLocal) {
      totalEmission *= 0.8; // 20% reduction for local food
    }

    return totalEmission;
  }

  // Calculate energy carbon footprint
  double calculateEnergyFootprint({
    required String energyType,
    required double consumption,
    required String unit,
    bool isRenewable = false,
  }) {
    String key = energyType.toLowerCase();
    if (isRenewable && key == 'electricity') {
      key = 'electricity_solar'; // Default renewable to solar
    }

    double emissionPerUnit = _energyEmissions[key] ?? _energyEmissions['electricity_grid']!;
    
    // Convert consumption to standard unit if needed
    double standardConsumption = consumption;
    if (unit.toLowerCase() == 'mwh') {
      standardConsumption *= 1000; // Convert MWh to kWh
    }

    return emissionPerUnit * standardConsumption;
  }

  // Calculate green points based on carbon savings
  int calculateGreenPoints(double carbonFootprintGrams) {
    if (carbonFootprintGrams < 0) {
      // Negative footprint means carbon savings - award points
      return (-carbonFootprintGrams / 10).round();
    } else if (carbonFootprintGrams < 500) {
      // Low footprint activities get some points
      return (100 - carbonFootprintGrams / 5).round().clamp(0, 100);
    } else {
      // High footprint activities get no points
      return 0;
    }
  }

  // Get carbon savings tips based on activity type
  List<String> getCarbonSavingTips(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'transportation':
        return [
          'Try biking or walking for short trips',
          'Use public transportation when possible',
          'Consider carpooling or ride-sharing',
          'Plan multiple errands in one trip',
          'Work from home when possible',
        ];
      case 'food':
        return [
          'Choose local and seasonal produce',
          'Reduce meat consumption, especially beef',
          'Try "Meatless Monday" or plant-based meals',
          'Avoid food waste by meal planning',
          'Choose organic options when available',
        ];
      case 'energy':
        return [
          'Switch to LED light bulbs',
          'Unplug electronics when not in use',
          'Use a programmable thermostat',
          'Consider renewable energy options',
          'Improve home insulation',
        ];
      case 'shopping':
        return [
          'Buy second-hand items when possible',
          'Choose products with minimal packaging',
          'Bring reusable bags when shopping',
          'Repair items instead of replacing them',
          'Support sustainable and local businesses',
        ];
      default:
        return [
          'Look for eco-friendly alternatives',
          'Reduce, reuse, and recycle',
          'Choose quality items that last longer',
          'Support environmentally conscious brands',
        ];
    }
  }

  // Calculate daily carbon budget (recommended daily limit in grams)
  double getDailyCarbonBudget() {
    // Based on 2030 climate targets: ~6 tons CO2 per person per year
    return (6000 * 1000) / 365; // ~16.4 kg per day in grams
  }

  // Get carbon footprint category
  String getCarbonFootprintCategory(double carbonGrams) {
    if (carbonGrams < 0) {
      return 'Carbon Negative';
    } else if (carbonGrams < 500) {
      return 'Low Impact';
    } else if (carbonGrams < 2000) {
      return 'Medium Impact';
    } else if (carbonGrams < 5000) {
      return 'High Impact';
    } else {
      return 'Very High Impact';
    }
  }

  // Get appropriate color for carbon footprint display
  String getCarbonFootprintColor(double carbonGrams) {
    if (carbonGrams < 0) {
      return '#4CAF50'; // Green for negative/savings
    } else if (carbonGrams < 500) {
      return '#8BC34A'; // Light green
    } else if (carbonGrams < 2000) {
      return '#FFC107'; // Yellow
    } else if (carbonGrams < 5000) {
      return '#FF9800'; // Orange
    } else {
      return '#F44336'; // Red
    }
  }
}
