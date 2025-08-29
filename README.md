# EcoFootprint Tracker - Complete Flutter App

A comprehensive Flutter mobile application that helps users track and reduce their environmental impact through daily activity logging, gamification, and community engagement.

## 🌱 Features

### Core Tracking System
- **Transportation Module**: Log commute methods, distance, vehicle type, and fuel efficiency
- **Food Impact Tracker**: Track meals, meat consumption, local vs imported foods
- **Energy Usage**: Input home energy consumption, appliance usage, renewable sources
- **Shopping Habits**: Track purchases, packaging waste, second-hand vs new items

### Gamification Elements
- **Green Points System**: Earn points for eco-friendly choices
- **Achievement Badges**: Unlock achievements like "Bike Week Champion", "Meatless Monday Streak"
- **Weekly Challenges**: Community-wide sustainability goals
- **Carbon Offset Goals**: Set and track monthly/yearly reduction targets
- **Streaks & Milestones**: Maintain consecutive days of sustainable choices

### Community Features
- **Local Leaderboards**: Compete with neighbors and friends
- **Team Challenges**: Create groups (families, offices, schools) with shared goals
- **Impact Sharing**: Post achievements and eco-tips to social feed
- **Green Business Integration**: Partner cafes, bike shops, organic stores

## 🏗️ Architecture

This app follows the **MVC (Model-View-Controller)** architecture pattern:

### Models (`lib/models/`)
- `user_model.dart` - User profiles, preferences, and statistics
- `activity_model.dart` - Activity logging and carbon calculations
- `achievement_model.dart` - Achievements, challenges, and leaderboards
- `business_model.dart` - Green businesses, rewards, and check-ins

### Views (`lib/views/`)
- **Screens**: Main application screens (dashboard, activity logging, profile, etc.)
- **Components**: Reusable UI components (cards, modals, banners)

### Controllers (`lib/controllers/`)
- `user_controller.dart` - User management and activity tracking
- `business_controller.dart` - Business discovery and rewards

### Services (`lib/services/`)
- `database_service.dart` - SQLite database management
- `carbon_calculation_service.dart` - Carbon footprint calculations
- `location_service.dart` - GPS and location-based features
- `notification_service.dart` - Push notifications and reminders

## 📱 Screens & Features

### 1. Onboarding & Authentication
- **Onboarding Screen**: Introduction to app features
- **Signup Screen**: User registration
- **Home Screen**: Main navigation hub

### 2. Dashboard
- Real-time carbon footprint overview
- Daily/weekly/monthly statistics
- Quick activity logging
- Recent activities timeline
- Progress towards goals

### 3. Activity Logging
- **Transportation**: Walk, bike, car, bus, plane with distance tracking
- **Food**: Plant-based, meat, dairy with quantity and source options
- **Energy**: Electricity, gas, renewable energy consumption
- **Shopping**: New vs used items, local vs imported
- **Other**: Recycling, composting, water conservation

### 4. Challenges & Achievements
- View available challenges
- Track achievement progress
- Community leaderboards
- Reward redemption

### 5. Community Hub
- Connect with other users
- Share progress and tips
- Discover local green businesses
- Join environmental initiatives

### 6. Profile & Settings
- User statistics and achievements
- App preferences
- Account management
- Carbon analytics

## 🛠️ Technical Implementation

### Dependencies
```yaml
dependencies:
  # Core Flutter
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.2
  
  # Navigation
  go_router: ^14.2.7
  
  # Database & Storage
  sqflite: ^2.3.3+1
  shared_preferences: ^2.2.3
  
  # Networking
  http: ^1.2.1
  dio: ^5.4.3+1
  
  # Location & Camera
  geolocator: ^11.0.0
  camera: ^0.10.5+9
  qr_code_scanner: ^1.0.1
  
  # Charts & Visualization
  fl_chart: ^0.68.0
  
  # Firebase (Push Notifications)
  firebase_core: ^2.31.1
  firebase_messaging: ^14.9.4
  flutter_local_notifications: ^17.2.2
  
  # Utilities
  intl: ^0.19.0
  uuid: ^4.4.0
  image_picker: ^1.1.2
  permission_handler: ^11.3.1
```

### Database Schema
- **users**: User profiles, preferences, stats
- **activities**: Daily activity logs with carbon calculations
- **achievements**: Available achievements and user progress
- **businesses**: Partner green businesses
- **rewards**: Available rewards and redemptions

### Carbon Calculation Engine
- Transportation emissions by vehicle type and fuel
- Food carbon intensity database
- Regional energy grid carbon factors
- Automatic carbon savings calculations
- Green points allocation system

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.5.3 or higher)
- Dart SDK (3.5.3 or higher)
- Android Studio / VS Code with Flutter extensions
- iOS development tools (for iOS deployment)

### Installation
1. Clone the repository:
```bash
git clone <repository-url>
cd eco_footprint_tracker
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate JSON serialization files:
```bash
flutter packages pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

### Building for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🎨 Design System

### Color Palette
- **Primary Green**: `#4CAF50` - Main brand color
- **Light Green**: `#8BC34A` - Secondary actions
- **Accent Orange**: `#FF9800` - Highlights and warnings
- **Background**: `#F1F8E9` - Light green background
- **Carbon Impact Colors**:
  - Negative (Savings): `#4CAF50` (Green)
  - Low Impact: `#8BC34A` (Light Green)
  - Medium Impact: `#FFC107` (Yellow)
  - High Impact: `#FF9800` (Orange)
  - Very High Impact: `#E53935` (Red)

### Typography
- **Font Family**: Inter (custom font)
- **Weights**: Regular (400), Medium (500), Bold (700)

## 📊 Data & Analytics

### Carbon Footprint Calculations
- **Transportation**: grams CO2 per kilometer by vehicle type
- **Food**: grams CO2 per 100g of food item
- **Energy**: grams CO2 per kWh/unit of energy
- **Modifiers**: Local sourcing, organic options, renewable energy

### User Engagement Metrics
- Daily active users
- Activities logged per user
- Carbon savings achieved
- Achievement unlock rates
- Community participation

## 🌍 Environmental Impact

### Goals
- Help users reduce personal carbon footprint by 20%
- Encourage sustainable transportation choices
- Promote plant-based eating
- Support local green businesses
- Build environmental awareness

### Measurement
- Total CO2 saved by all users
- Miles biked instead of driven
- Plastic waste reduced
- Local business support generated

## 🚧 Future Enhancements

### Phase 2 Features
- Carbon offset marketplace
- AI-powered sustainability recommendations
- Social media integration
- Corporate sustainability programs
- Integration with smart home devices

### Phase 3 Features
- Augmented reality for product scanning
- Machine learning for habit prediction
- Blockchain-based carbon credits
- Global environmental challenges
- Government and NGO partnerships

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Environmental organizations for carbon calculation data
- Open source community for the various packages used
- Beta testers and environmental advocates for feedback

## 📞 Support

For support, please contact [your-email@domain.com] or create an issue in the GitHub repository.

---

**Together, we can create a more sustainable future! 🌱**
