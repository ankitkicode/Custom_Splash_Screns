import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SplashRipple extends StatefulWidget {
  const SplashRipple({super.key});
  @override
  State<SplashRipple> createState() => _SplashRippleState();
}

class _SplashRippleState extends State<SplashRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    Timer(const Duration(seconds: 4), () =>
        Navigator.pushReplacementNamed(context, '/dashboard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomPaint(
        painter: _RipplePainter(animation: _ctrl),
        child: const SizedBox.expand(),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

class _RipplePainter extends CustomPainter {
  final Animation<double> animation;
  _RipplePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(1 - animation.value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final radius = (min(size.width, size.height) / 3) * animation.value;
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
