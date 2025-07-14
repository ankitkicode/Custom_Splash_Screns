import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class Splash1Glass extends StatefulWidget {
  const Splash1Glass({super.key});

  @override
  State<Splash1Glass> createState() => _Splash1GlassState();
}

class _Splash1GlassState extends State<Splash1Glass> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.black.withOpacity(0.2),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: 1.0,
                    child: Icon(Icons.ac_unit, size: 80, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Glass App',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
