import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/activity_model.dart';
import '../models/achievement_model.dart';
import '../models/business_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'eco_footprint.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        profile_image_url TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        preferences TEXT NOT NULL,
        stats TEXT NOT NULL
      )
    ''');

    // Activities table
    await db.execute('''
      CREATE TABLE activities(
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        carbon_footprint REAL NOT NULL,
        green_points_earned INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        metadata TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');

    // Achievements table
    await db.execute('''
      CREATE TABLE achievements(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        icon_url TEXT NOT NULL,
        category TEXT NOT NULL,
        points_required INTEGER NOT NULL,
        requirements TEXT,
        is_unlocked INTEGER DEFAULT 0,
        unlocked_at TEXT
      )
    ''');

    // User Achievements table (many-to-many)
    await db.execute('''
      CREATE TABLE user_achievements(
        user_id TEXT NOT NULL,
        achievement_id TEXT NOT NULL,
        unlocked_at TEXT NOT NULL,
        PRIMARY KEY(user_id, achievement_id),
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(achievement_id) REFERENCES achievements(id)
      )
    ''');

    // Challenges table
    await db.execute('''
      CREATE TABLE challenges(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        target_value INTEGER NOT NULL,
        unit TEXT NOT NULL,
        reward_points INTEGER NOT NULL,
        participants TEXT,
        is_active INTEGER DEFAULT 1,
        type TEXT NOT NULL
      )
    ''');

    // User Challenges table (many-to-many)
    await db.execute('''
      CREATE TABLE user_challenges(
        user_id TEXT NOT NULL,
        challenge_id TEXT NOT NULL,
        progress INTEGER DEFAULT 0,
        completed INTEGER DEFAULT 0,
        joined_at TEXT NOT NULL,
        PRIMARY KEY(user_id, challenge_id),
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(challenge_id) REFERENCES challenges(id)
      )
    ''');

    // Businesses table
    await db.execute('''
      CREATE TABLE businesses(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        address TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        category TEXT NOT NULL,
        certifications TEXT,
        rating REAL DEFAULT 0.0,
        review_count INTEGER DEFAULT 0,
        image_url TEXT,
        website_url TEXT,
        phone_number TEXT,
        hours TEXT,
        sustainability_features TEXT,
        points_multiplier TEXT
      )
    ''');

    // Rewards table
    await db.execute('''
      CREATE TABLE rewards(
        id TEXT PRIMARY KEY,
        business_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        points_cost INTEGER NOT NULL,
        image_url TEXT,
        expires_at TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        max_redemptions INTEGER DEFAULT -1,
        current_redemptions INTEGER DEFAULT 0,
        FOREIGN KEY(business_id) REFERENCES businesses(id)
      )
    ''');

    // User Rewards table (redemptions)
    await db.execute('''
      CREATE TABLE user_rewards(
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        reward_id TEXT NOT NULL,
        redeemed_at TEXT NOT NULL,
        used_at TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(reward_id) REFERENCES rewards(id)
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_activities_user_id ON activities(user_id)');
    await db.execute('CREATE INDEX idx_activities_timestamp ON activities(timestamp)');
    await db.execute('CREATE INDEX idx_businesses_location ON businesses(latitude, longitude)');
    
    // Insert sample data
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    // Insert sample achievements
    final sampleAchievements = [
      {
        'id': 'bike_week_champion',
        'name': 'Bike Week Champion',
        'description': 'Complete 7 consecutive days of biking to work',
        'icon_url': 'assets/icons/bike_champion.png',
        'category': 'transportation',
        'points_required': 100,
        'requirements': '{"consecutive_days": 7, "activity_type": "bike"}',
      },
      {
        'id': 'meatless_monday_streak',
        'name': 'Meatless Monday Streak',
        'description': 'Complete 4 consecutive Meatless Mondays',
        'icon_url': 'assets/icons/vegetarian.png',
        'category': 'food',
        'points_required': 80,
        'requirements': '{"consecutive_weeks": 4, "day": "monday", "no_meat": true}',
      },
      {
        'id': 'zero_waste_day',
        'name': 'Zero Waste Day',
        'description': 'Complete a full day with zero waste production',
        'icon_url': 'assets/icons/zero_waste.png',
        'category': 'shopping',
        'points_required': 150,
        'requirements': '{"waste_amount": 0, "duration": "day"}',
      },
    ];

    for (final achievement in sampleAchievements) {
      await db.insert('achievements', achievement);
    }

    // Insert sample businesses
    final sampleBusinesses = [
      {
        'id': 'green_cafe_1',
        'name': 'Eco Bean Café',
        'description': 'Organic coffee with compostable cups',
        'address': '123 Green Street, EcoCity',
        'latitude': 40.7128,
        'longitude': -74.0060,
        'category': 'restaurant',
        'certifications': '["organic", "fair_trade", "carbon_neutral"]',
        'rating': 4.8,
        'review_count': 127,
        'hours': '{"Monday": "07:00-19:00", "Tuesday": "07:00-19:00", "Wednesday": "07:00-19:00", "Thursday": "07:00-19:00", "Friday": "07:00-19:00", "Saturday": "08:00-18:00", "Sunday": "08:00-18:00"}',
        'sustainability_features': '["solar_powered", "compostable_packaging", "local_sourcing"]',
        'points_multiplier': '{"visit": 2, "purchase": 1}',
      },
      {
        'id': 'bike_shop_1',
        'name': 'Pedal Forward Bikes',
        'description': 'Electric and traditional bikes for sustainable transport',
        'address': '456 Cycle Lane, EcoCity',
        'latitude': 40.7589,
        'longitude': -73.9851,
        'category': 'transportation',
        'certifications': '["carbon_neutral", "sustainable_materials"]',
        'rating': 4.9,
        'review_count': 89,
        'hours': '{"Monday": "09:00-18:00", "Tuesday": "09:00-18:00", "Wednesday": "09:00-18:00", "Thursday": "09:00-18:00", "Friday": "09:00-18:00", "Saturday": "09:00-17:00"}',
        'sustainability_features': '["electric_bikes", "bike_recycling", "repair_services"]',
        'points_multiplier': '{"visit": 3, "purchase": 2}',
      },
    ];

    for (final business in sampleBusinesses) {
      await db.insert('businesses', business);
    }
  }

  // User methods
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'profile_image_url': user.profileImageUrl,
      'created_at': user.createdAt.toIso8601String(),
      'updated_at': user.updatedAt.toIso8601String(),
      'preferences': user.preferences.toJson().toString(),
      'stats': user.stats.toJson().toString(),
    });
  }

  Future<UserModel?> getUserById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      // Note: In a real app, you'd properly parse the JSON strings
      // For now, we'll create a basic user
      return UserModel(
        id: maps.first['id'],
        name: maps.first['name'],
        email: maps.first['email'],
        profileImageUrl: maps.first['profile_image_url'],
        createdAt: DateTime.parse(maps.first['created_at']),
        updatedAt: DateTime.parse(maps.first['updated_at']),
        preferences: UserPreferences(),
        stats: UserStats(lastActiveDate: DateTime.now()),
      );
    }
    return null;
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      {
        'name': user.name,
        'email': user.email,
        'profile_image_url': user.profileImageUrl,
        'updated_at': user.updatedAt.toIso8601String(),
        'preferences': user.preferences.toJson().toString(),
        'stats': user.stats.toJson().toString(),
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Activity methods
  Future<int> insertActivity(ActivityModel activity) async {
    final db = await database;
    return await db.insert('activities', {
      'id': activity.id,
      'user_id': activity.userId,
      'type': activity.type.name,
      'title': activity.title,
      'description': activity.description,
      'carbon_footprint': activity.carbonFootprint,
      'green_points_earned': activity.greenPointsEarned,
      'timestamp': activity.timestamp.toIso8601String(),
      'metadata': activity.metadata.toString(),
    });
  }

  Future<List<ActivityModel>> getActivitiesByUserId(String userId, {int limit = 50}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'activities',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) {
      return ActivityModel(
        id: maps[i]['id'],
        userId: maps[i]['user_id'],
        type: ActivityType.values.firstWhere(
          (e) => e.name == maps[i]['type'],
          orElse: () => ActivityType.other,
        ),
        title: maps[i]['title'],
        description: maps[i]['description'],
        carbonFootprint: maps[i]['carbon_footprint'],
        greenPointsEarned: maps[i]['green_points_earned'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
        metadata: {}, // In real app, parse the metadata JSON
      );
    });
  }

  Future<List<BusinessModel>> getBusinessesNearby(
    double latitude, 
    double longitude, 
    {double radiusKm = 10.0}
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('businesses');
    
    final List<BusinessModel> nearbyBusinesses = [];
    
    for (final map in maps) {
      final business = BusinessModel(
        id: map['id'],
        name: map['name'],
        description: map['description'] ?? '',
        address: map['address'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        category: map['category'],
        rating: map['rating'] ?? 0.0,
        reviewCount: map['review_count'] ?? 0,
        imageUrl: map['image_url'],
        websiteUrl: map['website_url'],
        phoneNumber: map['phone_number'],
        hours: BusinessHours(), // In real app, parse the JSON
      );
      
      if (business.distanceFrom(latitude, longitude) <= radiusKm) {
        nearbyBusinesses.add(business);
      }
    }
    
    return nearbyBusinesses;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
