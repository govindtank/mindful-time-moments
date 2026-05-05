import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/breathing_screen.dart';
import 'screens/mood_tracker_screen.dart';
import 'screens/relaxation_screen.dart';
import 'services/mood_service.dart';

class MindfulApp extends StatelessWidget {
  final MoodService moodService;

  const MindfulApp({super.key, required this.moodService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindful Time Moments',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF667eea),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF0F4FF),
      ),
      home: MainNavigator(moodService: moodService),
    );
  }
}

class MainNavigator extends StatefulWidget {
  final MoodService moodService;

  const MainNavigator({super.key, required this.moodService});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  void _onNavigate(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildScreen(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(key: const ValueKey('home'), onNavigate: _onNavigate);
      case 1:
        return const MeditationScreen(key: ValueKey('meditation'));
      case 2:
        return const BreathingScreen(key: ValueKey('breathing'));
      case 3:
        return MoodTrackerScreen(
          key: const ValueKey('mood'),
          moodService: widget.moodService,
        );
      case 4:
        return const RelaxationScreen(key: ValueKey('relaxation'));
      default:
        return HomeScreen(key: const ValueKey('home'), onNavigate: _onNavigate);
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              _buildNavItem(1, Icons.self_improvement, 'Meditate'),
              _buildNavItem(2, Icons.air, 'Breathe'),
              _buildNavItem(3, Icons.mood, 'Mood'),
              _buildNavItem(4, Icons.spa, 'Relax'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[400],
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
