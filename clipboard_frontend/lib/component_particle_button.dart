import 'dart:math' as math;
import 'package:flutter/material.dart';

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

class ParticleButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  const ParticleButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
    required this.borderRadius,
    required this.padding,
  }) : super(key: key);

  @override
  State<ParticleButton> createState() => _ParticleButtonState();
}

class _ParticleButtonState extends State<ParticleButton>
    with SingleTickerProviderStateMixin {
  final List<ParticleSprite> _particles = [];
  late AnimationController _controller;
  Offset? _tapPosition;

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
      const Color(0xFFD6B98D), // Sandy color
      const Color(0xFFE6CCAA), // Light sandy
      const Color(0xFFC2A172), // Dark sandy
    ];

    for (int i = 0; i < 20; i++) {
      final color = particleColors[random.nextInt(particleColors.length)];
      _particles.add(ParticleSprite(
        position.dx,
        position.dy,
        color: color,
        size: random.nextDouble() * 3 + 1,
      ));
    }
    _controller.forward(from: 0);
  }

  void _handleTapDown(TapDownDetails details) {
    _tapPosition = details.localPosition;
  }

  void _handleTap() {
    if (_tapPosition != null) {
      _createParticles(_tapPosition!);
    }
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTap: _handleTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: widget.borderRadius,
            ),
            child: widget.child,
          ),
          if (_particles.isNotEmpty)
            Positioned.fill(
              child: CustomPaint(
                painter: ParticlePainter(particles: _particles),
              ),
            ),
        ],
      ),
    );
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
