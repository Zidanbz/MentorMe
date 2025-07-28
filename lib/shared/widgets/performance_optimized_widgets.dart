import 'package:flutter/material.dart';

/// Optimized StatelessWidget that prevents unnecessary rebuilds
class OptimizedStatelessWidget extends StatelessWidget {
  final Widget Function(BuildContext context) builder;
  final List<Object?> dependencies;

  const OptimizedStatelessWidget({
    super.key,
    required this.builder,
    this.dependencies = const [],
  });

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OptimizedStatelessWidget) return false;

    return listEquals(dependencies, other.dependencies);
  }

  @override
  int get hashCode => Object.hashAll(dependencies);
}

/// Optimized Container that reduces paint operations
class OptimizedContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;

  const OptimizedContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: padding,
        margin: margin,
        color: color,
        decoration: decoration,
        width: width,
        height: height,
        constraints: constraints,
        alignment: alignment,
        child: child,
      ),
    );
  }
}

/// Optimized ListView that uses RepaintBoundary for better performance
class OptimizedListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final Axis scrollDirection;

  const OptimizedListView({
    super.key,
    required this.children,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: ValueKey('list_item_$index'),
          child: children[index],
        );
      },
    );
  }
}

/// Optimized GridView with RepaintBoundary
class OptimizedGridView extends StatelessWidget {
  final List<Widget> children;
  final SliverGridDelegate gridDelegate;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  const OptimizedGridView({
    super.key,
    required this.children,
    required this.gridDelegate,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: gridDelegate,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: ValueKey('grid_item_$index'),
          child: children[index],
        );
      },
    );
  }
}

/// Optimized Text widget that prevents unnecessary rebuilds
class OptimizedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const OptimizedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OptimizedText) return false;

    return text == other.text &&
        style == other.style &&
        textAlign == other.textAlign &&
        maxLines == other.maxLines &&
        overflow == other.overflow;
  }

  @override
  int get hashCode => Object.hash(text, style, textAlign, maxLines, overflow);
}

/// Optimized Card widget with RepaintBoundary
class OptimizedCard extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;

  const OptimizedCard({
    super.key,
    this.child,
    this.color,
    this.elevation,
    this.shape,
    this.margin,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        color: color,
        elevation: elevation,
        shape: shape,
        margin: margin,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }
}

/// Mixin for performance monitoring
mixin PerformanceMonitorMixin<T extends StatefulWidget> on State<T> {
  late Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    debugPrint(
        '${widget.runtimeType} lifecycle: ${_stopwatch.elapsedMilliseconds}ms');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buildStopwatch = Stopwatch()..start();
    final widget = buildWidget(context);
    buildStopwatch.stop();

    if (buildStopwatch.elapsedMilliseconds > 16) {
      debugPrint(
          '${this.widget.runtimeType} build took: ${buildStopwatch.elapsedMilliseconds}ms');
    }

    return widget;
  }

  Widget buildWidget(BuildContext context);
}

/// Optimized AnimatedBuilder that reduces rebuilds
class OptimizedAnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext context, double value) builder;
  final Widget? child;

  const OptimizedAnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return RepaintBoundary(
          child: builder(context, animation.value),
        );
      },
    );
  }
}

/// Utility function to check if list equals
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  if (identical(a, b)) return true;
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}
