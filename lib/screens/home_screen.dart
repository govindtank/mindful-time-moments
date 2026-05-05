import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/gradient_background.dart';
import '../widgets/animated_card.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: const [
        Color(0xFF667eea),
        Color(0xFF764ba2),
        Color(0xFF6B8DD6),
        Color(0xFF8E37D7),
      ],
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return SingleChildScrollView(
              padding: EdgeInsets.all(isWide ? 32 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  _buildGreeting(context),
                  const SizedBox(height: 32),
                  _buildFeatureGrid(context, isWide),
                  const SizedBox(height: 32),
                  _buildTip(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mindful',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Time Moments',
              style: GoogleFonts.poppins(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.self_improvement, color: Colors.white, size: 28),
        ),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) greeting = 'Good Afternoon';
    if (hour >= 17) greeting = 'Good Evening';

    return AnimatedCard(
      index: 0,
      color: Colors.white.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.wb_sunny, color: Colors.amber, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Take a moment to breathe and center yourself today.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, bool isWide) {
    final features = [
      _FeatureItem(
        icon: Icons.timer_outlined,
        title: 'Meditation',
        subtitle: 'Guided timer sessions',
        color: const Color(0xFF6C63FF),
        gradient: const [Color(0xFF667eea), Color(0xFF764ba2)],
      ),
      _FeatureItem(
        icon: Icons.air,
        title: 'Breathing',
        subtitle: 'Calm your mind',
        color: const Color(0xFF43C6AC),
        gradient: const [Color(0xFF43C6AC), Color(0xFF191654)],
      ),
      _FeatureItem(
        icon: Icons.mood,
        title: 'Mood Tracker',
        subtitle: 'Track your feelings',
        color: const Color(0xFFFF6B6B),
        gradient: const [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
      ),
      _FeatureItem(
        icon: Icons.spa,
        title: 'Relaxation',
        subtitle: 'Sound & visuals',
        color: const Color(0xFF4ECDC4),
        gradient: const [Color(0xFF4ECDC4), Color(0xFF556270)],
      ),
    ];

    if (isWide) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.2,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) => _buildFeatureCard(context, features[index], index),
      );
    }

    return Column(
      children: List.generate(
        features.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildFeatureCard(context, features[index], index),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, _FeatureItem feature, int index) {
    return AnimatedCard(
      index: index + 1,
      onTap: () => onNavigate(index),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: feature.gradient.map((c) => c.withOpacity(0.15)).toList(),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: feature.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(feature.icon, color: feature.color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    feature.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    feature.subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(BuildContext context) {
    final tips = [
      'Take 5 deep breaths right now',
      'A 10-minute meditation can change your day',
      'Notice 3 things around you',
      'Your mood matters — track it daily',
      'Breathe in for 4, out for 4',
    ];
    final tip = tips[DateTime.now().day % tips.length];

    return AnimatedCard(
      index: 5,
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tip,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final List<Color> gradient;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradient,
  });
}
