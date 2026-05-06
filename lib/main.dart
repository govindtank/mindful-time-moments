import 'package:flutter/material.dart';
import 'app.dart';
import 'services/mood_service.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.init();
  final moodService = await MoodService.create();
  runApp(MindfulApp(moodService: moodService));
}
