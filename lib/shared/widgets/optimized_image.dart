import 'package:flutter/material.dart';

class OptimizedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  State<OptimizedImage> createState() => _OptimizedImageState();
}

class _OptimizedImageState extends State<OptimizedImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: _hasError
            ? _buildErrorWidget()
            : Stack(
                children: [
                  if (_isLoading) _buildShimmerPlaceholder(),
                  Image.network(
                    widget.imageUrl,
                    width: widget.width,
                    height: widget.height,
                    fit: widget.fit,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() => _isLoading = false);
                            _animationController.stop();
                          }
                        });
                        return child;
                      }
                      return _buildShimmerPlaceholder();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                            _hasError = true;
                          });
                          _animationController.stop();
                        }
                      });
                      return _buildErrorWidget();
                    },
                    // Optimasi memory dengan cacheWidth dan cacheHeight
                    cacheWidth: widget.width?.toInt(),
                    cacheHeight: widget.height?.toInt(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return widget.placeholder ??
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[300]!.withOpacity(_animation.value),
                    Colors.grey[100]!.withOpacity(_animation.value),
                    Colors.grey[300]!.withOpacity(_animation.value),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            );
          },
        );
  }

  Widget _buildErrorWidget() {
    return widget.errorWidget ??
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[200],
          child: const Icon(
            Icons.error_outline,
            color: Colors.grey,
            size: 32,
          ),
        );
  }
}
