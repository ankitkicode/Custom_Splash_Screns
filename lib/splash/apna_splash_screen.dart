import 'dart:async';
import 'package:flutter/material.dart';
// Ab aapko home_screen.dart import karne ki zaroorat nahi hai
// kyunki hum named route ka istemal kar rahe hain.

// SplashScreen ke liye StatefulWidget
class ApnaSplashScreen extends StatefulWidget {
  const ApnaSplashScreen({Key? key}) : super(key: key);

  @override
  State<ApnaSplashScreen> createState() => _ApnaSplashScreenState();
}

// Animation ke liye SingleTickerProviderStateMixin ka istemal
class _ApnaSplashScreenState extends State<ApnaSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // AnimationController ko initialize karein
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Ek curved animation banayein
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    // Animation shuru karein
    _controller.forward();

    // 3 second ke baad '/dashboard' route par redirect karein
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  @override
  void dispose() {
    // Widget hatne par controller ko dispose karein
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Splash screen ka background color
      backgroundColor: const Color(0xFFF0F8FF), // Halka Alice Blue color
      body: Center(
        // Logo aur text ko animate karne ke liye ScaleTransition ka istemal
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App ka logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.work_outline_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),
              // App ka naam
              const Text(
                'apna App',
                style: TextStyle(
                  fontSize: 48,
                  // fontWeight: 'bold',
                  color: Color(0xFF0D47A1), // Gehra neela color
                  fontFamily: 'sans-serif-condensed',
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
