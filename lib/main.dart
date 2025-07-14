import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import './splash/splash_spotify.dart'; // Make sure this file exists

void main() => runApp(const DashboardApp());

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
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
        '/': (context) => const SplashSpotify(), // ⬅ Splash shown first
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
