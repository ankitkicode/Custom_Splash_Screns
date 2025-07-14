import 'dart:async';
import 'package:flutter/material.dart';

class SplashCircularProgress extends StatefulWidget {
  const SplashCircularProgress({super.key});

  @override
  State<SplashCircularProgress> createState() => _SplashCircularProgressState();
}

class _SplashCircularProgressState extends State<SplashCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    Timer(const Duration(seconds: 4), () =>
        Navigator.pushReplacementNamed(context, '/dashboard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: FadeTransition(
          opacity: _ctrl,
          child: const CircularProgressIndicator(color: Colors.cyanAccent, strokeWidth: 6),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
