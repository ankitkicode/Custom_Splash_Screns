import 'dart:async';
import 'package:flutter/material.dart';

class Splash3Neumorphic extends StatefulWidget {
  const Splash3Neumorphic({super.key});

  @override
  State<Splash3Neumorphic> createState() => _Splash3NeumorphicState();
}

class _Splash3NeumorphicState extends State<Splash3Neumorphic>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    _bounce = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      body: Center(
        child: ScaleTransition(
          scale: _bounce,
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E5EC),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-8, -8),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: Color(0xFFA3B1C6),
                  offset: Offset(8, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(Icons.flutter_dash, size: 60, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
