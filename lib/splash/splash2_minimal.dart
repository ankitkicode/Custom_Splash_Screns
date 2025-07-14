import 'dart:async';
import 'package:flutter/material.dart';

class Splash2Minimal extends StatefulWidget {
  const Splash2Minimal({super.key});

  @override
  State<Splash2Minimal> createState() => _Splash2MinimalState();
}

class _Splash2MinimalState extends State<Splash2Minimal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Text(
            "Minimal App",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
