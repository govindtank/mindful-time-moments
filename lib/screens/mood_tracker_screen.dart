import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood_entry.dart';
import '../services/mood_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/animated_card.dart';

class MoodTrackerScreen extends StatefulWidget {
  final MoodService moodService;
  final bool isDarkMode;

  const MoodTrackerScreen({
    super.key,
    required this.moodService,
    required this.isDarkMode,
  });

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  int _selectedMood = 3;
  final TextEditingController _noteController = TextEditingController();
  List<MoodEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    setState(() {
      _entries = widget.moodService.getRecentEntries(30);
    });
  }

  Future<void> _saveMood() async {
    final entry = MoodEntry(
      date: DateTime.now(),
      moodLevel: _selectedMood,
      note: _noteController.text.trim(),
      moodEmoji: MoodEntry.getEmoji(_selectedMood),
    );
    await widget.moodService.saveEntry(entry);
    _noteController.clear();
    _loadEntries();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mood saved: ${MoodEntry.getEmoji(_selectedMood)} ${MoodEntry.getLabel(_selectedMood)}',
          ),
          backgroundColor: const Color(0xFF667eea),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // ─── Dark-aware helpers ───────────────────────────────────────────────────

  Color get _cardBg         => widget.isDarkMode ? const Color(0xFF1E1E30) : Colors.white;
  Color get _textPrimary     => widget.isDarkMode ? const Color(0xFFF0F0FF) : const Color(0xFF2D3748);
  Color get _textSecondary   => widget.isDarkMode ? Colors.white54 : Colors.grey[600]!;
  Color get _textMuted       => widget.isDarkMode ? Colors.white38 : Colors.grey[400]!;
  Color get _textDarker      => widget.isDarkMode ? Colors.white70 : Colors.grey[700]!;
  Color get _chipUnselected  => widget.isDarkMode ? Colors.white12 : Colors.grey[100]!;
  Color get _chipDot         => widget.isDarkMode ? Colors.white30 : Colors.grey[300]!;
  Color get _inputFill       => widget.isDarkMode ? Colors.white.withOpacity(0.08) : Colors.grey[50]!;
  Color get _gridLine        => widget.isDarkMode ? Colors.white12 : Colors.grey[200]!;

  @override
  Widget build(BuildContext context) {
    return SoftGradientBackground(
      isDarkMode: widget.isDarkMode,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMoodSelector(context),
              const SizedBox(height: 24),
              _buildNoteInput(context),
              const SizedBox(height: 24),
              _buildSaveButton(context),
              const SizedBox(height: 24),
              if (_entries.isNotEmpty) ...[
                _buildMoodChart(context),
                const SizedBox(height: 24),
                _buildRecentEntries(context),
              ],
              if (_entries.isEmpty) _buildEmptyState(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedCard(
      index: 0,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.mood, color: Color(0xFFFF6B6B), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mood Tracker',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  Text(
                    'How are you feeling right now?',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: _textSecondary,
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

  Widget _buildMoodSelector(BuildContext context) {
    return AnimatedCard(
      index: 1,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              MoodEntry.getEmoji(_selectedMood),
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 8),
            Text(
              MoodEntry.getLabel(_selectedMood),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: _getMoodColor(_selectedMood),
                inactiveTrackColor: _chipUnselected,
                thumbColor: _getMoodColor(_selectedMood),
                overlayColor: _getMoodColor(_selectedMood).withOpacity(0.2),
                trackHeight: 8,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
              ),
              child: Slider(
                value: _selectedMood.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (v) => setState(() => _selectedMood = v.round()),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (i) {
                final level = i + 1;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = level),
                  child: Column(
                    children: [
                      Text(
                        MoodEntry.getEmoji(level),
                        style: TextStyle(
                          fontSize: level == _selectedMood ? 28 : 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: level == _selectedMood
                              ? _getMoodColor(level)
                              : _chipDot,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(int level) {
    switch (level) {
      case 1: return Colors.red[400]!;
      case 2: return Colors.orange[400]!;
      case 3: return Colors.amber[400]!;
      case 4: return Colors.lightGreen[400]!;
      case 5: return Colors.green[400]!;
      default: return Colors.amber;
    }
  }

  Widget _buildNoteInput(BuildContext context) {
    return AnimatedCard(
      index: 2,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a note (optional)',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 3,
              style: GoogleFonts.poppins(fontSize: 14, color: _textPrimary),
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: _textMuted,
                ),
                filled: true,
                fillColor: _inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF667eea),
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return GestureDetector(
      onTap: _saveMood,
      child: AnimatedCard(
        index: 3,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'Save Mood',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodChart(BuildContext context) {
    final recent = _entries.take(7).toList().reversed.toList();
    if (recent.isEmpty) return const SizedBox.shrink();

    return AnimatedCard(
      index: 4,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last 7 Days',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: _gridLine,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value < 1 || value > 5) return const SizedBox();
                          return Text(
                            MoodEntry.getEmoji(value.toInt()),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= recent.length) return const SizedBox();
                          final date = recent[value.toInt()].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${date.day}/${date.month}',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: _textMuted,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (recent.length - 1).toDouble(),
                  minY: 0.5,
                  maxY: 5.5,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        recent.length,
                        (i) => FlSpot(i.toDouble(), recent[i].moodLevel.toDouble()),
                      ),
                      isCurved: true,
                      color: const Color(0xFFFF6B6B),
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: widget.isDarkMode
                                ? const Color(0xFF1E1E30)
                                : Colors.white,
                            strokeWidth: 2,
                            strokeColor: const Color(0xFFFF6B6B),
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFFFF6B6B).withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentEntries(BuildContext context) {
    final recent = _entries.take(10).toList().reversed.toList();
    return AnimatedCard(
      index: 5,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Entries',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...recent.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Text(entry.moodEmoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MoodEntry.getLabel(entry.moodLevel),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _textPrimary,
                              ),
                            ),
                            if (entry.note.isNotEmpty)
                              Text(
                                entry.note,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: _textMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Text(
                        _formatDate(entry.date),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AnimatedCard(
      index: 4,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Text('🗓️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'No mood entries yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your mood to see your history here',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: _textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${date.day}/${date.month}';
  }
}
