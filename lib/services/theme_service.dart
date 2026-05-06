import 'package:shared_preferences/shared_preferences.dart';

/// Persists dark mode preference across sessions using SharedPreferences.
class ThemeService {
  static const String _keyDarkMode = 'mindful_dark_mode';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Returns the saved dark mode preference. Defaults to false (light mode).
  static bool get isDarkMode => _prefs?.getBool(_keyDarkMode) ?? false;

  /// Saves the dark mode preference.
  static Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool(_keyDarkMode, value);
  }
}
