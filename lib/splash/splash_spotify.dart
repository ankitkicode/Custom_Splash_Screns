import 'dart:async';
import 'package:flutter/material.dart';

class SplashSpotify extends StatefulWidget {
  const SplashSpotify({super.key});

  @override
  State<SplashSpotify> createState() => _SplashSpotifyState();
}

class _SplashSpotifyState extends State<SplashSpotify>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Logo Animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeIn = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    _scaleIn = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoController.forward();

    // Glow Effect Animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  static const Color spotifyGreen = Color(0xFF1DB954);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: ScaleTransition(
            scale: _scaleIn,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: spotifyGreen.withOpacity(_glowAnimation.value),
                            blurRadius: 40,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Image.asset(
                        'assets/spotify_logo.png',
                        width: 110,
                        height: 110,
                        color: Colors.white, // Ensures it matches Spotify white logo
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _fadeIn,
                  child: const Text(
                    "Spotify",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: spotifyGreen,
                      letterSpacing: 1.2,
                      fontFamily: 'Poppins',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
