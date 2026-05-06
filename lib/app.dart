import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/breathing_screen.dart';
import 'screens/mood_tracker_screen.dart';
import 'screens/relaxation_screen.dart';
import 'services/mood_service.dart';
import 'services/theme_service.dart';

class MindfulApp extends StatefulWidget {
  final MoodService moodService;

  const MindfulApp({super.key, required this.moodService});

  @override
  State<MindfulApp> createState() => _MindfulAppState();
}

class _MindfulAppState extends State<MindfulApp> {
  bool _isDarkMode = ThemeService.isDarkMode;

  void _toggleTheme() async {
    final next = !_isDarkMode;
    await ThemeService.setDarkMode(next);
    setState(() => _isDarkMode = next);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindful Time Moments',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeAnimationDuration: const Duration(milliseconds: 400),
      themeAnimationCurve: Curves.easeInOut,
      home: MainNavigator(
        moodService: widget.moodService,
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF667eea),
        brightness: Brightness.light,
        primary: const Color(0xFF667eea),
        secondary: const Color(0xFF764ba2),
        tertiary: const Color(0xFF6B8DD6),
        surface: const Color(0xFFF5F7FF),
        onSurface: const Color(0xFF1A1A2E),
        surfaceContainerHighest: const Color(0xFFE8EEFF),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F7FF),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: const Color(0xFF1A1A2E),
        displayColor: const Color(0xFF1A1A2E),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: Color(0xFF1A1A2E)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF667eea)),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF667eea),
        brightness: Brightness.dark,
        primary: const Color(0xFF818CF8),
        secondary: const Color(0xFFA78BFA),
        tertiary: const Color(0xFF6B8DD6),
        surface: const Color(0xFF0F0F1A),
        onSurface: const Color(0xFFF0F0FF),
        surfaceContainerHighest: const Color(0xFF1A1A2E),
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0A14),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: const Color(0xFFF0F0FF),
        displayColor: const Color(0xFFF0F0FF),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF151525),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2A2A45)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Color(0xFFF0F0FF)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF818CF8)),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2A45),
        thickness: 1,
      ),
    );
  }
}

class MainNavigator extends StatefulWidget {
  final MoodService moodService;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const MainNavigator({
    super.key,
    required this.moodService,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

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
    final isDark = widget.isDarkMode;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildScreen(),
      ),
      bottomNavigationBar: _buildBottomNav(isDark, primaryColor),
    );
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          key: const ValueKey('home'),
          onNavigate: _onNavigate,
          isDarkMode: widget.isDarkMode,
          onThemeToggle: widget.onThemeToggle,
        );
      case 1:
        return MeditationScreen(
          key: const ValueKey('meditation'),
          isDarkMode: widget.isDarkMode,
        );
      case 2:
        return BreathingScreen(
          key: const ValueKey('breathing'),
          isDarkMode: widget.isDarkMode,
        );
      case 3:
        return MoodTrackerScreen(
          key: const ValueKey('mood'),
          moodService: widget.moodService,
          isDarkMode: widget.isDarkMode,
        );
      case 4:
        return RelaxationScreen(
          key: const ValueKey('relaxation'),
          isDarkMode: widget.isDarkMode,
        );
      default:
        return HomeScreen(
          key: const ValueKey('home'),
          onNavigate: _onNavigate,
          isDarkMode: widget.isDarkMode,
          onThemeToggle: widget.onThemeToggle,
        );
    }
  }

  Widget _buildBottomNav(bool isDark, Color primaryColor) {
    final bgColor = isDark
        ? const Color(0xFF0A0A14).withOpacity(0.95)
        : Colors.white.withOpacity(0.95);
    final textColor = isDark ? const Color(0xFFF0F0FF) : const Color(0xFF1A1A2E);
    final mutedColor = isDark ? Colors.white38 : Colors.grey.shade400;
    final selectedBg = isDark
        ? primaryColor.withOpacity(0.25)
        : primaryColor.withOpacity(0.12);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.5)
                : Colors.black.withOpacity(0.06),
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
              _buildNavItem(0, Icons.home_rounded, 'Home', textColor, mutedColor, selectedBg),
              _buildNavItem(1, Icons.self_improvement, 'Meditate', textColor, mutedColor, selectedBg),
              _buildNavItem(2, Icons.air, 'Breathe', textColor, mutedColor, selectedBg),
              _buildNavItem(3, Icons.mood, 'Mood', textColor, mutedColor, selectedBg),
              _buildNavItem(4, Icons.spa, 'Relax', textColor, mutedColor, selectedBg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    Color textColor,
    Color mutedColor,
    Color selectedBg,
  ) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                )
              : null,
          color: isSelected ? null : selectedBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : mutedColor,
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
