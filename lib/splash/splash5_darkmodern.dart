import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash5DarkModern extends StatefulWidget {
  const Splash5DarkModern({super.key});

  @override
  State<Splash5DarkModern> createState() => _Splash5DarkModernState();
}

class _Splash5DarkModernState extends State<Splash5DarkModern> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Center(
        child: Lottie.asset('assets/modern_dark_animation.json', width: 200),
      ),
    );
  }
}
