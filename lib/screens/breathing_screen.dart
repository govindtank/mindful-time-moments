import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/gradient_background.dart';
import '../widgets/animated_card.dart';

class BreathingScreen extends StatefulWidget {
  final bool isDarkMode;

  const BreathingScreen({super.key, required this.isDarkMode});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with TickerProviderStateMixin {
  int _selectedPattern = 0;
  bool _isActive = false;
  String _instruction = 'Tap to Start';
  int _currentCycle = 0;
  Timer? _timer;

  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  final List<_BreathingPattern> _patterns = [
    _BreathingPattern('Box Breathing', 4, 4, 4, 4),
    _BreathingPattern('4-7-8 Relaxing', 4, 7, 8, 0),
    _BreathingPattern('Energizing', 2, 0, 4, 0),
    _BreathingPattern('Calm', 6, 0, 6, 0),
  ];

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(vsync: this);
    _breathAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isActive = true;
      _currentCycle = 0;
    });
    _runCycle();
  }

  void _stopBreathing() {
    _timer?.cancel();
    _breathController.stop();
    _breathController.reset();
    setState(() {
      _isActive = false;
      _instruction = 'Tap to Start';
    });
  }

  void _runCycle() {
    final pattern = _patterns[_selectedPattern];
    int step = 0;

    void nextStep() {
      if (!mounted || !_isActive) return;

      switch (step) {
        case 0:
          _animateBreath(pattern.inhale, isInhale: true);
          setState(() => _instruction = 'Breathe In');
          step++;
          _timer = Timer(Duration(seconds: pattern.inhale), nextStep);
          break;
        case 1:
          if (pattern.holdAfterInhale > 0) {
            setState(() => _instruction = 'Hold');
            _timer = Timer(
                Duration(seconds: pattern.holdAfterInhale), () {
              step++;
              nextStep();
            });
          } else {
            step++;
            nextStep();
          }
          break;
        case 2:
          _animateBreath(pattern.exhale, isInhale: false);
          setState(() => _instruction = 'Breathe Out');
          step++;
          _timer = Timer(Duration(seconds: pattern.exhale), nextStep);
          break;
        case 3:
          if (pattern.holdAfterExhale > 0) {
            setState(() => _instruction = 'Hold');
            _timer = Timer(
                Duration(seconds: pattern.holdAfterExhale), () {
              _completeCycle();
            });
          } else {
            _completeCycle();
          }
          break;
      }
    }

    nextStep();
  }

  void _completeCycle() {
    if (!mounted || !_isActive) return;
    setState(() {
      _currentCycle++;
      _instruction = '$_currentCycle cycle${_currentCycle > 1 ? 's' : ''}';
    });
    _runCycle();
  }

  void _animateBreath(int seconds, {required bool isInhale}) {
    _breathController.duration = Duration(seconds: seconds);
    if (isInhale) {
      _breathController.forward(from: 0);
    } else {
      _breathController.reverse(from: 1);
    }
  }

  // ─── Dark-aware helpers ───────────────────────────────────────────────────

  Color get _cardBg       => widget.isDarkMode ? const Color(0xFF1E1E30) : Colors.white;
  Color get _textPrimary   => widget.isDarkMode ? const Color(0xFFF0F0FF) : const Color(0xFF2D3748);
  Color get _textSecondary => widget.isDarkMode ? Colors.white54 : Colors.grey[600]!;
  Color get _textMuted     => widget.isDarkMode ? Colors.white38 : Colors.grey[500]!;
  Color get _chipUnselected=> widget.isDarkMode ? Colors.white12 : Colors.grey[50]!;

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
              _buildBreathingCircle(context),
              const SizedBox(height: 24),
              if (!_isActive) _buildPatternSelector(context),
              if (_isActive) _buildCycleCounter(context),
              const SizedBox(height: 24),
              _buildControlButton(context),
              const SizedBox(height: 24),
              _buildInstructions(context),
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
                color: const Color(0xFF43C6AC).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.air, color: Color(0xFF43C6AC), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Breathing Exercise',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  Text(
                    'Calm your nervous system with guided breathing',
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

  Widget _buildBreathingCircle(BuildContext context) {
    return AnimatedCard(
      index: 1,
      color: _cardBg,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _breathAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _breathAnimation.value,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF43C6AC), Color(0xFF191654)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF43C6AC).withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isActive) ...[
                            Text(
                              _instruction,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ] else ...[
                            const Icon(Icons.air, color: Colors.white54, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              'Ready',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            if (_isActive)
              Text(
                _patterns[_selectedPattern].name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF43C6AC),
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternSelector(BuildContext context) {
    return AnimatedCard(
      index: 2,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a Pattern',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(_patterns.length, (i) {
              final p = _patterns[i];
              final isSelected = _selectedPattern == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedPattern = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF43C6AC).withOpacity(0.12)
                        : _chipUnselected,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF43C6AC)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFF43C6AC)
                              : _textMuted,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? _textPrimary
                                    : _textSecondary,
                              ),
                            ),
                            Text(
                              p.description,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: _textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleCounter(BuildContext context) {
    return AnimatedCard(
      index: 2,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '$_currentCycle',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF43C6AC),
              ),
            ),
            Text(
              'Cycles Completed',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(BuildContext context) {
    return GestureDetector(
      onTap: _isActive ? _stopBreathing : _startBreathing,
      child: AnimatedCard(
        index: 3,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isActive
                  ? [Colors.red[400]!, Colors.red[600]!]
                  : [const Color(0xFF43C6AC), const Color(0xFF191654)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (_isActive ? Colors.red : const Color(0xFF43C6AC))
                    .withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isActive ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                _isActive ? 'Stop Exercise' : 'Start Breathing',
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

  Widget _buildInstructions(BuildContext context) {
    return AnimatedCard(
      index: 4,
      color: _cardBg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How it works',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildInstructionRow('Sit comfortably with a straight back'),
            _buildInstructionRow('Place one hand on your chest, one on belly'),
            _buildInstructionRow('Breathe through your nose slowly'),
            _buildInstructionRow('Follow the circle\'s rhythm'),
            _buildInstructionRow('Keep your shoulders relaxed'),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.circle, color: const Color(0xFF43C6AC), size: 10),
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

class _BreathingPattern {
  final String name;
  final int inhale;
  final int holdAfterInhale;
  final int exhale;
  final int holdAfterExhale;

  _BreathingPattern(
      this.name, this.inhale, this.holdAfterInhale, this.exhale, this.holdAfterExhale);

  String get description {
    final parts = <String>[];
    parts.add('In $inhale');
    if (holdAfterInhale > 0) parts.add('Hold $holdAfterInhale');
    parts.add('Out $exhale');
    if (holdAfterExhale > 0) parts.add('Hold $holdAfterExhale');
    return parts.join(' - ');
  }
}
