import 'dart:async';
import 'package:flutter/material.dart';

class SplashNetflix extends StatefulWidget {
  const SplashNetflix({super.key});
  @override
  State<SplashNetflix> createState() => _SplashNetflixState();
}

class _SplashNetflixState extends State<SplashNetflix>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.5).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutExpo));
    _controller.forward();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnim,
          child: const Text(
            "N",
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
        ),
      ),
    );
  }
}
