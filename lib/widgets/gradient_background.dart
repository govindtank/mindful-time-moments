import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ??
              [
                const Color(0xFF667eea),
                const Color(0xFF764ba2),
                const Color(0xFF6B8DD6),
                const Color(0xFF8E37D7),
              ],
        ),
      ),
      child: child,
    );
  }
}

class SoftGradientBackground extends StatelessWidget {
  final Widget child;

  const SoftGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF0F4FF),
            Color(0xFFE8F0FE),
            Color(0xFFF5F0FF),
          ],
        ),
      ),
      child: child,
    );
  }
}
