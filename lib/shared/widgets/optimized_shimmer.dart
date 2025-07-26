import 'package:flutter/material.dart';

class OptimizedShimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;
  final bool enabled;

  const OptimizedShimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
  });

  @override
  State<OptimizedShimmer> createState() => _OptimizedShimmerState();
}

class _OptimizedShimmerState extends State<OptimizedShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.enabled) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _animation.value, 0.0),
              end: Alignment(1.0 + _animation.value, 0.0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// Pre-built shimmer components
class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerCard({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return OptimizedShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class ShimmerText extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerText({
    super.key,
    required this.width,
    this.height = 16,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return OptimizedShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  final double radius;

  const ShimmerCircle({
    super.key,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return OptimizedShimmer(
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// Pre-built shimmer layouts
class ShimmerListTile extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;
  final int titleLines;
  final int subtitleLines;

  const ShimmerListTile({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.titleLines = 1,
    this.subtitleLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (hasLeading) ...[
            const ShimmerCircle(radius: 24),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title lines
                for (int i = 0; i < titleLines; i++) ...[
                  ShimmerText(
                    width: i == titleLines - 1 ? 120 : double.infinity,
                    height: 16,
                  ),
                  if (i < titleLines - 1) const SizedBox(height: 4),
                ],
                if (subtitleLines > 0) const SizedBox(height: 8),
                // Subtitle lines
                for (int i = 0; i < subtitleLines; i++) ...[
                  ShimmerText(
                    width: i == subtitleLines - 1 ? 80 : double.infinity,
                    height: 12,
                  ),
                  if (i < subtitleLines - 1) const SizedBox(height: 4),
                ],
              ],
            ),
          ),
          if (hasTrailing) ...[
            const SizedBox(width: 16),
            const ShimmerText(width: 60, height: 20),
          ],
        ],
      ),
    );
  }
}

class ShimmerGridItem extends StatelessWidget {
  final double aspectRatio;
  final bool hasTitle;
  final bool hasSubtitle;

  const ShimmerGridItem({
    super.key,
    this.aspectRatio = 1.0,
    this.hasTitle = true,
    this.hasSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: const ShimmerCard(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        if (hasTitle) ...[
          const SizedBox(height: 8),
          const ShimmerText(width: double.infinity, height: 16),
        ],
        if (hasSubtitle) ...[
          const SizedBox(height: 4),
          const ShimmerText(width: 100, height: 12),
        ],
      ],
    );
  }
}

// Loading states for specific components
class LoadingProjectCard extends StatelessWidget {
  const LoadingProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerCard(width: double.infinity, height: 120),
            const SizedBox(height: 12),
            const ShimmerText(width: double.infinity, height: 18),
            const SizedBox(height: 8),
            const ShimmerText(width: 150, height: 14),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ShimmerText(width: 80, height: 16),
                ShimmerCard(
                  width: 60,
                  height: 24,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingChatItem extends StatelessWidget {
  const LoadingChatItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ShimmerCircle(radius: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerText(width: double.infinity, height: 16),
                SizedBox(height: 6),
                ShimmerText(width: 120, height: 12),
              ],
            ),
          ),
          SizedBox(width: 16),
          ShimmerText(width: 40, height: 12),
        ],
      ),
    );
  }
}

class LoadingProfileHeader extends StatelessWidget {
  const LoadingProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          ShimmerCircle(radius: 50),
          SizedBox(height: 16),
          ShimmerText(width: 200, height: 24),
          SizedBox(height: 8),
          ShimmerText(width: 120, height: 16),
          SizedBox(height: 16),
          ShimmerText(width: double.infinity, height: 14),
          SizedBox(height: 4),
          ShimmerText(width: 180, height: 14),
        ],
      ),
    );
  }
}
