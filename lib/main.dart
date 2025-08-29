import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/user_controller.dart';
import 'controllers/business_controller.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/onboarding_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const EcoFootprintApp());
}

class EcoFootprintApp extends StatelessWidget {
  const EcoFootprintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => BusinessController()),
      ],
      child: MaterialApp(
        title: 'EcoFootprint Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const AppInitializer(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;
  bool _hasUser = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate checking for existing user
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real app, you'd check SharedPreferences or secure storage
    // for existing user session
    
    setState(() {
      _isInitialized = true;
      _hasUser = false; // Set to true if user exists
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.eco,
                size: 80,
                color: Colors.green,
              ),
              SizedBox(height: 24),
              Text(
                'EcoFootprint Tracker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(
                color: Colors.green,
              ),
            ],
          ),
        ),
      );
    }

    return _hasUser ? const HomeScreen() : const OnboardingScreen();
  }
}
