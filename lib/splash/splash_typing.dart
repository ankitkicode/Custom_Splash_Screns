import 'dart:async';
import 'package:flutter/material.dart';

class SplashTyping extends StatefulWidget {
  const SplashTyping({super.key});

  @override
  State<SplashTyping> createState() => _SplashTypingState();
}

class _SplashTypingState extends State<SplashTyping> {
  String _text = "";
  final String _full = "Welcome to Task Dashboard";
  int _index = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_index < _full.length) {
        setState(() => _text += _full[_index++]);
      } else {
        t.cancel();
        Timer(const Duration(seconds: 2), () =>
            Navigator.pushReplacementNamed(context, '/dashboard'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          _text,
          style: const TextStyle(color: Colors.cyanAccent, fontSize: 24),
        ),
      ),
    );
  }
}
