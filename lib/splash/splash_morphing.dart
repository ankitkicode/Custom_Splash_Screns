import 'dart:async';
import 'package:flutter/material.dart';

class SplashMorphing extends StatefulWidget {
  const SplashMorphing({super.key});

  @override
  State<SplashMorphing> createState() => _SplashMorphingState();
}

class _SplashMorphingState extends State<SplashMorphing> {
  double _size = 100;
  Color _color = Colors.cyan;

  @override
  void initState() {
    super.initState();
    _animate();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  void _animate() {
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _size = _size == 100 ? 150 : 100;
        _color = _color == Colors.cyan ? Colors.deepPurpleAccent : Colors.cyan;
      });
      _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          width: _size,
          height: _size,
          decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(_size / 2)),
        ),
      ),
    );
  }
}
