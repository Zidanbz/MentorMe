import 'package:flutter/material.dart';

/// Consistent background widget for all app features
class AppBackground extends StatelessWidget {
  final Widget child;
  final bool showFloatingElements;
  final double opacity;

  const AppBackground({
    super.key,
    required this.child,
    this.showFloatingElements = true,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFe0fff3), // Light mint green
            Color(0xFF339989), // Teal green
            Color(0xFF3c493f), // Dark green
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          if (showFloatingElements) _buildFloatingElements(),
          child,
        ],
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Stack(
      children: [
        // Top right floating circle
        Positioned(
          top: 80,
          right: 30,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF339989).withOpacity(0.08),
            ),
          ),
        ),
        // Top left floating circle
        Positioned(
          top: 150,
          left: 20,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFe0fff3).withOpacity(0.15),
            ),
          ),
        ),
        // Middle right floating circle
        Positioned(
          top: 300,
          right: 60,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3c493f).withOpacity(0.1),
            ),
          ),
        ),
        // Bottom left floating circle
        Positioned(
          bottom: 200,
          left: 40,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF339989).withOpacity(0.06),
            ),
          ),
        ),
        // Bottom right floating circle
        Positioned(
          bottom: 100,
          right: 20,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFe0fff3).withOpacity(0.12),
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated background with subtle floating elements
class AnimatedAppBackground extends StatefulWidget {
  final Widget child;
  final bool showFloatingElements;

  const AnimatedAppBackground({
    super.key,
    required this.child,
    this.showFloatingElements = true,
  });

  @override
  State<AnimatedAppBackground> createState() => _AnimatedAppBackgroundState();
}

class _AnimatedAppBackgroundState extends State<AnimatedAppBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -3.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFe0fff3), // Light mint green
            Color(0xFF339989), // Teal green
            Color(0xFF3c493f), // Dark green
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          if (widget.showFloatingElements) _buildAnimatedFloatingElements(),
          widget.child,
        ],
      ),
    );
  }

  Widget _buildAnimatedFloatingElements() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            // Animated floating circles with minimal movement
            Positioned(
              top: 80 + _animation.value,
              right: 30,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF339989).withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              top: 150 - _animation.value * 0.5,
              left: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFe0fff3).withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              top: 300 + _animation.value * 0.8,
              right: 60,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3c493f).withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: 200 - _animation.value,
              left: 40,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF339989).withOpacity(0.06),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Card with consistent app styling
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF339989).withOpacity(0.1),
            blurRadius: elevation ?? 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}
