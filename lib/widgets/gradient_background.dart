import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final bool isDarkMode;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ??
              (isDarkMode
                  ? [
                      const Color(0xFF1A1A2E),
                      const Color(0xFF16213E),
                      const Color(0xFF0F3460),
                      const Color(0xFF2C1654),
                    ]
                  : [
                      const Color(0xFF667eea),
                      const Color(0xFF764ba2),
                      const Color(0xFF6B8DD6),
                      const Color(0xFF8E37D7),
                    ]),
        ),
      ),
      child: child,
    );
  }
}

class SoftGradientBackground extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;

  const SoftGradientBackground({
    super.key,
    required this.child,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [
                  const Color(0xFF0A0A14),
                  const Color(0xFF0F0F1A),
                  const Color(0xFF151525),
                ]
              : [
                  const Color(0xFFF0F4FF),
                  const Color(0xFFE8F0FE),
                  const Color(0xFFF5F0FF),
                ],
        ),
      ),
      child: child,
    );
  }
}
