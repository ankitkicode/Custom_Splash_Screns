import 'dart:async';
import 'package:flutter/material.dart';

class Splash4Gradient extends StatefulWidget {
  const Splash4Gradient({super.key});

  @override
  State<Splash4Gradient> createState() => _Splash4GradientState();
}

class _Splash4GradientState extends State<Splash4Gradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
    _slide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: SlideTransition(
        position: _slide,
        child: Center(
          child: Text(
            'Gradient App',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
