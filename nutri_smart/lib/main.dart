import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database_service.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'providers/meal_provider.dart';
import 'providers/food_provider.dart';
import 'themes/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
      ],
      child: const NutriSmartApp(),
    ),
  );
}

class NutriSmartApp extends StatelessWidget {
  const NutriSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return MaterialApp(
      title: 'NutriSmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: userProvider.isAuthenticated 
          ? const MainScreen() 
          : const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
