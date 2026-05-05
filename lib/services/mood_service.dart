import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

class MoodService {
  static const String _key = 'mood_entries';
  final SharedPreferences _prefs;

  MoodService(this._prefs);

  static Future<MoodService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return MoodService(prefs);
  }

  List<MoodEntry> getEntries() {
    final data = _prefs.getString(_key);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.map((e) => MoodEntry.fromJson(e)).toList();
  }

  Future<void> saveEntry(MoodEntry entry) async {
    final entries = getEntries();
    entries.add(entry);
    final data = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, data);
  }

  Future<void> clearEntries() async {
    await _prefs.remove(_key);
  }

  List<MoodEntry> getRecentEntries(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return getEntries().where((e) => e.date.isAfter(cutoff)).toList();
  }
}
