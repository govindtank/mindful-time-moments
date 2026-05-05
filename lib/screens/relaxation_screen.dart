import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/gradient_background.dart';
import '../widgets/animated_card.dart';

class RelaxationScreen extends StatefulWidget {
  const RelaxationScreen({super.key});

  @override
  State<RelaxationScreen> createState() => _RelaxationScreenState();
}

class _RelaxationScreenState extends State<RelaxationScreen>
    with TickerProviderStateMixin {
  int _selectedAmbient = 0;
  bool _isPlaying = false;
  late AnimationController _waveController;

  final List<_AmbientSound> _sounds = [
    _AmbientSound('🌧️', 'Rain', 'gentle rainfall'),
    _AmbientSound('🌊', 'Ocean', 'waves on shore'),
    _AmbientSound('🍃', 'Wind', 'soft breeze'),
    _AmbientSound('🔥', 'Fire', 'crackling fire'),
    _AmbientSound('🦋', 'Forest', 'birds & nature'),
    _AmbientSound('💫', 'Space', 'ambient tones'),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SoftGradientBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildVisualizer(context),
              const SizedBox(height: 24),
              _buildSoundSelector(context),
              const SizedBox(height: 24),
              _buildPlayButton(context),
              const SizedBox(height: 24),
              _buildAffirmations(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedCard(
      index: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.spa, color: Color(0xFF4ECDC4), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Relaxation Zone',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    'Unwind with soothing sounds and visuals',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
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

  Widget _buildVisualizer(BuildContext context) {
    return AnimatedCard(
      index: 1,
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            return Column(
              children: [
                Text(
                  _isPlaying ? _sounds[_selectedAmbient].emoji : '🎧',
                  style: TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 16),
                Text(
                  _isPlaying ? _sounds[_selectedAmbient].name : 'Ready to Relax',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                if (_isPlaying) ...[
                  const SizedBox(height: 4),
                  Text(
                    _sounds[_selectedAmbient].description,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(20, (i) {
                      final random = Random(i);
                      final baseHeight = _isPlaying ? 10 + random.nextInt(40) : 10;
                      final animated = _isPlaying
                          ? baseHeight * (0.5 + 0.5 * _waveController.value * random.nextDouble())
                          : baseHeight * 0.5;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 8,
                          height: animated,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: _isPlaying
                                  ? [
                                      Color.lerp(
                                        const Color(0xFF4ECDC4),
                                        const Color(0xFF556270),
                                        i / 20,
                                      )!,
                                      Color.lerp(
                                        const Color(0xFF556270),
                                        const Color(0xFF4ECDC4),
                                        i / 20,
                                      )!,
                                    ]
                                  : [
                                      Colors.grey[300]!,
                                      Colors.grey[200]!,
                                    ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSoundSelector(BuildContext context) {
    return AnimatedCard(
      index: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ambient Sounds',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: _sounds.length,
              itemBuilder: (context, i) {
                final sound = _sounds[i];
                final isSelected = _selectedAmbient == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedAmbient = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4ECDC4).withOpacity(0.15)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF4ECDC4)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(sound.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(
                          sound.name,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF4ECDC4)
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isPlaying = !_isPlaying),
      child: AnimatedCard(
        index: 3,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isPlaying
                  ? [Colors.grey[500]!, Colors.grey[600]!]
                  : [const Color(0xFF4ECDC4), const Color(0xFF556270)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (_isPlaying ? Colors.grey : const Color(0xFF4ECDC4))
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
                _isPlaying ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                _isPlaying ? 'Stop Sound' : 'Play Ambient Sound',
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

  Widget _buildAffirmations(BuildContext context) {
    final affirmations = [
      'I am at peace with myself',
      'Every breath brings calm',
      'I release all tension',
      'I am worthy of happiness',
      'This moment is enough',
    ];

    return AnimatedCard(
      index: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✨ Daily Affirmation',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF667eea).withOpacity(0.1),
                    const Color(0xFF764ba2).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('💭', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      affirmations[DateTime.now().day % affirmations.length],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF667eea),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Breathe deeply and repeat this affirmation to yourself.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmbientSound {
  final String emoji;
  final String name;
  final String description;

  _AmbientSound(this.emoji, this.name, this.description);
}
