import 'package:flutter/material.dart';
import 'app.dart';
import 'services/mood_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final moodService = await MoodService.create();
  runApp(MindfulApp(moodService: moodService));
}
