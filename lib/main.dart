import 'package:demo_flutter_project/splash/splash1_glass.dart';
import 'package:demo_flutter_project/splash/splash2_minimal.dart';
import 'package:demo_flutter_project/splash/splash3_neumorphic.dart';
import 'package:demo_flutter_project/splash/splash4_gradient.dart';
import 'package:demo_flutter_project/splash/splash5_darkmodern.dart';
import 'package:demo_flutter_project/splash/splash_circular_progress.dart';
import 'package:demo_flutter_project/splash/splash_hotstar.dart';
import 'package:demo_flutter_project/splash/splash_morphing.dart';
import 'package:demo_flutter_project/splash/splash_netflix.dart';
import 'package:demo_flutter_project/splash/splash_ripple.dart';
import 'package:demo_flutter_project/splash/splash_skewed_slide.dart';
import 'package:demo_flutter_project/splash/splash_spotify.dart';
import 'package:demo_flutter_project/splash/splash_youtube.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
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
        '/': (context) => const SplashYoutube(), // ⬅ Splash shown first
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
