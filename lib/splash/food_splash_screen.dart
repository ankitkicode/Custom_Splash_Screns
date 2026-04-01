import 'dart:async';
import 'package:flutter/material.dart';

class FoodSplashScreen extends StatefulWidget {
  const FoodSplashScreen({super.key});

  @override
  _FoodSplashScreenState createState() => _FoodSplashScreenState();
}

// Add SingleTickerProviderStateMixin for animation controller
class _FoodSplashScreenState extends State<FoodSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Create a curved animation for a smooth effect
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Create scale animation for the logo
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(curve);

    // Create fade animation for the text
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);

    // Start the animation
    _controller.forward();

    // Navigate to the dashboard after a 3-second delay
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Use pushReplacementNamed to prevent going back to the splash screen
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    });
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Add a modern gradient background with white and grey
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Apply scale animation to the logo
              ScaleTransition(
                scale: _scaleAnimation,
                child:
                    const Text('🍔', style: TextStyle(fontSize: 120)),
              ),
              const SizedBox(height: 24),
              // Apply fade animation to the text
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'Food Dash',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Updated for light background
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your next meal, just a tap away.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700], // Updated for light background
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              // Add a subtle loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor), // Updated for light background
              ),
            ],
          ),
        ),
      ),
    );
  }
}

