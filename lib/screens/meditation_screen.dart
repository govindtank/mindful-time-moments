import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/gradient_background.dart';
import '../widgets/animated_card.dart';

class MeditationScreen extends StatefulWidget {
  final bool isDarkMode;

  const MeditationScreen({super.key, required this.isDarkMode});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with TickerProviderStateMixin {
  int _selectedMinutes = 5;
  bool _isRunning = false;
  int _remainingSeconds = 0;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<int> _durations = [3, 5, 10, 15, 20, 30];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _remainingSeconds = _selectedMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _remainingSeconds = _selectedMinutes * 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _showCompletionDialog();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _selectedMinutes * 60;
    });
  }

  void _showCompletionDialog() {
    final isDark = widget.isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('🧘 Well Done!',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'You completed your meditation session. Keep up the great work!',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Continue',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ─── Dark-aware helpers ───────────────────────────────────────────────────

  Color get _cardBg       => widget.isDarkMode ? const Color(0xFF1E1E30) : Colors.white;
  Color get _textPrimary   => widget.isDarkMode ? const Color(0xFFF0F0FF) : const Color(0xFF2D3748);
  Color get _textSecondary => widget.isDarkMode ? Colors.white54 : Colors.grey[600]!;
  Color get _textMuted     => widget.isDarkMode ? Colors.white38 : Colors.grey[500]!;
  Color get _chipUnselected=> widget.isDarkMode ? Colors.white12 : Colors.grey[100]!;

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
              const SizedBox(height: 32),
              _buildTimer(context),
              const SizedBox(height: 32),
              if (!_isRunning) _buildDurationPicker(context),
              const SizedBox(height: 24),
              _buildControls(context),
              const SizedBox(height: 32),
              _buildTips(context),
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF667eea).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.self_improvement,
                color: Color(0xFF667eea),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Meditation Timer',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your session length and find your inner peace',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer(BuildContext context) {
    return AnimatedCard(
      index: 1,
      color: _cardBg,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isRunning ? _pulseAnimation.value : 1.0,
                  child: child,
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667eea).withOpacity(0.35),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _formatTime(_remainingSeconds),
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isRunning)
              Text(
                'Breathe deeply...',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFF667eea),
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              Text(
                'Ready to begin',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: _textMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationPicker(BuildContext context) {
    return AnimatedCard(
      index: 2,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session Duration',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _durations.map((min) {
                final isSelected = _selectedMinutes == min;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedMinutes = min;
                    _remainingSeconds = min * 60;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)])
                          : null,
                      color: isSelected ? null : _chipUnselected,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$min min',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : _textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return AnimatedCard(
      index: 3,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              icon: Icons.refresh,
              label: 'Reset',
              onTap: _resetTimer,
              color: _textSecondary,
            ),
            _buildMainButton(),
            _buildControlButton(
              icon: Icons.pause,
              label: 'Pause',
              onTap: _isRunning ? _pauseTimer : null,
              color: _textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return GestureDetector(
      onTap: _isRunning ? _pauseTimer : _startTimer,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667eea).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          _isRunning ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTips(BuildContext context) {
    return AnimatedCard(
      index: 4,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💡 Tips',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildTipRow('Find a quiet, comfortable space'),
            _buildTipRow('Sit or lie down with a straight spine'),
            _buildTipRow('Focus on your breath — inhale and exhale'),
            _buildTipRow('Let thoughts pass without judgment'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF667eea), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 13, color: _textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
