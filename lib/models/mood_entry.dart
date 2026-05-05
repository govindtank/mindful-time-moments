class MoodEntry {
  final DateTime date;
  final int moodLevel; // 1-5
  final String note;
  final String moodEmoji;

  MoodEntry({
    required this.date,
    required this.moodLevel,
    this.note = '',
    this.moodEmoji = '',
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'moodLevel': moodLevel,
        'note': note,
        'moodEmoji': moodEmoji,
      };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
        date: DateTime.parse(json['date']),
        moodLevel: json['moodLevel'],
        note: json['note'] ?? '',
        moodEmoji: json['moodEmoji'] ?? '',
      );

  static String getEmoji(int level) {
    switch (level) {
      case 1:
        return '😢';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😊';
      default:
        return '😐';
    }
  }

  static String getLabel(int level) {
    switch (level) {
      case 1:
        return 'Very Low';
      case 2:
        return 'Low';
      case 3:
        return 'Neutral';
      case 4:
        return 'Good';
      case 5:
        return 'Great';
      default:
        return 'Neutral';
    }
  }
}
