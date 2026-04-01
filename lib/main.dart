import 'package:demo_flutter_project/dashboard/dashboard_screen_2.dart';
import 'package:demo_flutter_project/splash/food_splash_screen.dart';
import 'package:flutter/material.dart';
import '/dashboard/dashboard_screen_2.dart';
// Make sure this file exists

void main() => runApp(const DashboardApp());

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Poppins',
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.lightBlueAccent,
        ),
      ),
      // Start app with splash screen
      initialRoute: '/',
      routes: {
        '/': (context) => const FoodSplashScreen(), // ⬅ Splash shown first
        '/dashboard': (context) => const DashboardScreen2(),
      },
    );
  }
}
