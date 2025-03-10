import 'package:flutter/material.dart';
import 'dart:math' as math;

class EnterButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;

  const EnterButton({
    Key? key,
    required this.onPressed,
    this.width = 180,
    this.height = 45,
  }) : super(key: key);

  @override
  State<EnterButton> createState() => _EnterButtonState();
}

class _EnterButtonState extends State<EnterButton>
    with SingleTickerProviderStateMixin {
  final List<ParticleSprite> _particles = [];
  late AnimationController _controller;
  Offset? _tapPosition;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(_updateParticles);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateParticles() {
    if (!mounted) return;
    setState(() {
      _particles.removeWhere((particle) => !particle.update());
    });
  }

  void _createParticles(Offset position) {
    final random = math.Random();
    final particleColors = [
      const Color(0xFFDAC6A4), // Light sand
      const Color(0xFFE6D5B8), // Pale sand
      const Color(0xFFC2B280), // Dark sand
      const Color(0xFFD4C4A8), // Neutral sand
    ];

    for (int i = 0; i < 30; i++) {
      final color = particleColors[random.nextInt(particleColors.length)];
      _particles.add(ParticleSprite(
        position.dx,
        position.dy,
        color: color,
        size: random.nextDouble() * 4 + 2,
      ));
    }
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (details) => _tapPosition = details.localPosition,
        onTap: () {
          if (_tapPosition != null) {
            _createParticles(_tapPosition!);
          }
          widget.onPressed();
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: _isHovered
                    ? Colors.indigo.shade800.withOpacity(0.9)
                    : Colors.indigo.shade800,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2A8277).withOpacity(0.3),
                    blurRadius: _isHovered ? 12 : 8,
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform.rotate(
                      angle: -math.pi / 4,
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_particles.isNotEmpty)
              Positioned.fill(
                child: CustomPaint(
                  painter: ParticlePainter(particles: _particles),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Reuse the ParticleSprite and ParticlePainter classes from before
class ParticleSprite {
  late double x;
  late double y;
  late double velocityX;
  late double velocityY;
  late double size;
  late double alpha;
  late Color color;

  ParticleSprite(
    this.x,
    this.y, {
    required this.color,
    this.size = 2.0,
  }) {
    velocityX = (math.Random().nextDouble() - 0.5) * 8.0;
    velocityY = (math.Random().nextDouble() - 0.5) * 8.0;
    alpha = 1.0;
  }

  bool update() {
    x += velocityX;
    y += velocityY;
    alpha *= 0.92;
    size *= 0.92;
    return alpha > 0.1;
  }
}

class ParticlePainter extends CustomPainter {
  final List<ParticleSprite> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.alpha)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
