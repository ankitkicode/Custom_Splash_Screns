import 'dart:async';
import 'package:flutter/material.dart';

class SplashSkewedSlide extends StatefulWidget {
  const SplashSkewedSlide({super.key});

  @override
  State<SplashSkewedSlide> createState() => _SplashSkewedSlideState();
}

class _SplashSkewedSlideState extends State<SplashSkewedSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _slide = Tween(begin: const Offset(-1.5, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
    Timer(const Duration(seconds: 4), () =>
        Navigator.pushReplacementNamed(context, '/dashboard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SlideTransition(
        position: _slide,
        child: Transform(
          transform: Matrix4.skewY(-0.2),
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(24),
            color: Colors.purpleAccent,
            child: const Center(
              child: Text(
                "Hello App!",
                style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
