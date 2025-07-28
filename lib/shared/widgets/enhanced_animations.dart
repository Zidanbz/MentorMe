import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentorme/app/constants/app_colors.dart';

// Enhanced Fade In Animation with more options
class OptimizedFadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool autoStart;
  final VoidCallback? onComplete;

  const OptimizedFadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
    this.autoStart = true,
    this.onComplete,
  });

  @override
  State<OptimizedFadeIn> createState() => _OptimizedFadeInState();
}

class _OptimizedFadeInState extends State<OptimizedFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    if (widget.autoStart) {
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void start() {
    if (mounted) _controller.forward();
  }

  void reverse() {
    if (mounted) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

// Enhanced Combined Fade + Slide Animation
class OptimizedFadeSlide extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final Offset slideBegin;
  final Offset slideEnd;
  final bool autoStart;
  final VoidCallback? onComplete;

  const OptimizedFadeSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
    this.slideBegin = const Offset(0.0, 0.3),
    this.slideEnd = Offset.zero,
    this.autoStart = true,
    this.onComplete,
  });

  @override
  State<OptimizedFadeSlide> createState() => _OptimizedFadeSlideState();
}

class _OptimizedFadeSlideState extends State<OptimizedFadeSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _slideAnimation =
        Tween<Offset>(begin: widget.slideBegin, end: widget.slideEnd).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    if (widget.autoStart) {
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

// Scale Animation
class OptimizedScale extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double begin;
  final double end;
  final bool autoStart;
  final VoidCallback? onComplete;

  const OptimizedScale({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.curve = Curves.elasticOut,
    this.begin = 0.0,
    this.end = 1.0,
    this.autoStart = true,
    this.onComplete,
  });

  @override
  State<OptimizedScale> createState() => _OptimizedScaleState();
}

class _OptimizedScaleState extends State<OptimizedScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    if (widget.autoStart) {
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

// Interactive Hover Animation
class OptimizedHover extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double scale;
  final double elevation;
  final Color? shadowColor;
  final VoidCallback? onTap;
  final VoidCallback? onHover;
  final bool enableHaptic;

  const OptimizedHover({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.scale = 1.05,
    this.elevation = 8.0,
    this.shadowColor,
    this.onTap,
    this.onHover,
    this.enableHaptic = true,
  });

  @override
  State<OptimizedHover> createState() => _OptimizedHoverState();
}

class _OptimizedHoverState extends State<OptimizedHover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 0.0, end: widget.elevation)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent details) {
    setState(() => _isHovered = true);
    _controller.forward();
    widget.onHover?.call();
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
  }

  void _onExit(PointerEvent details) {
    setState(() => _isHovered = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: (widget.shadowColor ?? AppColors.primary)
                          .withOpacity(0.3 *
                              _elevationAnimation.value /
                              widget.elevation),
                      blurRadius: _elevationAnimation.value,
                      spreadRadius: _elevationAnimation.value / 4,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                  ],
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Staggered List Animation
class OptimizedStaggeredList extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration staggerDelay;
  final Curve curve;
  final Axis direction;

  const OptimizedStaggeredList({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 600),
    this.staggerDelay = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
    this.direction = Axis.vertical,
  });

  @override
  State<OptimizedStaggeredList> createState() => _OptimizedStaggeredListState();
}

class _OptimizedStaggeredListState extends State<OptimizedStaggeredList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return OptimizedFadeSlide(
          delay: widget.staggerDelay * index,
          duration: widget.duration,
          curve: widget.curve,
          slideBegin: widget.direction == Axis.vertical
              ? const Offset(0.0, 0.5)
              : const Offset(0.5, 0.0),
          child: child,
        );
      }).toList(),
    );
  }
}

// Enhanced Page Transition Animation
class OptimizedPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final PageTransitionType transitionType;
  final Duration duration;
  final Duration reverseDuration;
  final Curve curve;

  OptimizedPageRoute({
    required this.child,
    this.transitionType = PageTransitionType.slideRight,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            switch (transitionType) {
              case PageTransitionType.fade:
                return FadeTransition(opacity: curvedAnimation, child: child);

              case PageTransitionType.slideRight:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: child,
                );

              case PageTransitionType.slideLeft:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: child,
                );

              case PageTransitionType.slideUp:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: child,
                );

              case PageTransitionType.scale:
                return ScaleTransition(
                  scale: curvedAnimation,
                  child: FadeTransition(
                    opacity: curvedAnimation,
                    child: child,
                  ),
                );

              case PageTransitionType.rotation:
                return RotationTransition(
                  turns: curvedAnimation,
                  child: FadeTransition(
                    opacity: curvedAnimation,
                    child: child,
                  ),
                );

              case PageTransitionType.size:
                return SizeTransition(
                  sizeFactor: curvedAnimation,
                  child: child,
                );
            }
          },
        );
}

enum PageTransitionType {
  fade,
  slideRight,
  slideLeft,
  slideUp,
  scale,
  rotation,
  size,
}

// Helper function for easy navigation with animation
extension NavigatorExtension on NavigatorState {
  Future<T?> pushWithAnimation<T extends Object?>(
    Widget page, {
    PageTransitionType transitionType = PageTransitionType.slideRight,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return push<T>(OptimizedPageRoute<T>(
      child: page,
      transitionType: transitionType,
      duration: duration,
      curve: curve,
    ));
  }
}
