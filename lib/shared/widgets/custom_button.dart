import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentorme/app/constants/app_colors.dart';
import 'package:mentorme/global/Fontstyle.dart';

enum ButtonType { primary, secondary, outline, text, gradient, glass }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double height;
  final IconData? icon;
  final Widget? iconWidget;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool enableHapticFeedback;
  final bool enableShadow;
  final bool enableGlow;
  final Duration animationDuration;
  final List<BoxShadow>? customShadows;
  final Gradient? customGradient;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.height = 56,
    this.icon,
    this.iconWidget,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 16,
    this.padding,
    this.enableHapticFeedback = true,
    this.enableShadow = true,
    this.enableGlow = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.customShadows,
    this.customGradient,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.isFullWidth ? double.infinity : widget.width,
            height: widget.height,
            decoration: _buildDecoration(isDisabled),
            child: _buildButton(isDisabled),
          ),
        );
      },
    );
  }

  BoxDecoration _buildDecoration(bool isDisabled) {
    List<BoxShadow> shadows = [];

    if (widget.enableShadow && !isDisabled) {
      if (widget.customShadows != null) {
        shadows = widget.customShadows!;
      } else {
        shadows = _getDefaultShadows();
      }
    }

    if (widget.enableGlow && !isDisabled) {
      shadows.add(
        BoxShadow(
          color: AppColors.primary.withOpacity(0.3 * _glowAnimation.value),
          blurRadius: 20 * _glowAnimation.value,
          spreadRadius: 2 * _glowAnimation.value,
        ),
      );
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: shadows,
    );
  }

  List<BoxShadow> _getDefaultShadows() {
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.gradient:
        return [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ];
      case ButtonType.secondary:
        return [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ];
      case ButtonType.glass:
        return [
          BoxShadow(
            color: AppColors.shadow,
            offset: const Offset(0, 8),
            blurRadius: 32,
            spreadRadius: 0,
          ),
        ];
      default:
        return [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ];
    }
  }

  Widget _buildButton(bool isDisabled) {
    return GestureDetector(
      onTapDown: isDisabled ? null : _handleTapDown,
      onTapUp: isDisabled ? null : _handleTapUp,
      onTapCancel: isDisabled ? null : _handleTapCancel,
      onTap: isDisabled ? null : widget.onPressed,
      child: Container(
        decoration: _buildButtonDecoration(isDisabled),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            splashColor: _getSplashColor(),
            highlightColor: _getHighlightColor(),
            onTap: isDisabled ? null : () {},
            child: Container(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: _buildButtonContent(isDisabled),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildButtonDecoration(bool isDisabled) {
    switch (widget.type) {
      case ButtonType.primary:
        return BoxDecoration(
          color: isDisabled
              ? AppColors.interactiveDisabled
              : (widget.backgroundColor ?? AppColors.primary),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        );

      case ButtonType.secondary:
        return BoxDecoration(
          color: isDisabled
              ? AppColors.interactiveDisabled
              : (widget.backgroundColor ?? AppColors.primaryLight),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        );

      case ButtonType.gradient:
        return BoxDecoration(
          gradient: isDisabled
              ? null
              : (widget.customGradient ?? AppColors.primaryGradient),
          color: isDisabled ? AppColors.interactiveDisabled : null,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        );

      case ButtonType.glass:
        return BoxDecoration(
          color: isDisabled
              ? AppColors.interactiveDisabled.withOpacity(0.1)
              : AppColors.glass,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: isDisabled ? AppColors.borderLight : AppColors.glassBorder,
            width: 1,
          ),
        );

      case ButtonType.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: isDisabled
                ? AppColors.borderLight
                : (widget.backgroundColor ?? AppColors.primary),
            width: 2,
          ),
        );

      case ButtonType.text:
        return BoxDecoration(
          color: _isPressed && !isDisabled
              ? AppColors.highlight
              : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        );
    }
  }

  Color _getSplashColor() {
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.gradient:
        return AppColors.ripple;
      case ButtonType.secondary:
        return AppColors.primary.withOpacity(0.1);
      case ButtonType.glass:
        return AppColors.glassLight;
      case ButtonType.outline:
      case ButtonType.text:
        return AppColors.rippleLight;
    }
  }

  Color _getHighlightColor() {
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.gradient:
        return AppColors.interactivePressed.withOpacity(0.1);
      case ButtonType.secondary:
        return AppColors.primary.withOpacity(0.05);
      case ButtonType.glass:
        return AppColors.glassLight;
      case ButtonType.outline:
      case ButtonType.text:
        return AppColors.highlight;
    }
  }

  Widget _buildButtonContent(bool isDisabled) {
    if (widget.isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getLoadingColor(isDisabled),
          ),
        ),
      );
    }

    final content = <Widget>[];

    if (widget.iconWidget != null) {
      content.add(widget.iconWidget!);
      if (widget.text.isNotEmpty) {
        content.add(const SizedBox(width: 12));
      }
    } else if (widget.icon != null) {
      content.add(
        Icon(
          widget.icon,
          size: 20,
          color: _getContentColor(isDisabled),
        ),
      );
      if (widget.text.isNotEmpty) {
        content.add(const SizedBox(width: 12));
      }
    }

    if (widget.text.isNotEmpty) {
      content.add(
        Text(
          widget.text,
          style: AppTextStyles.button.copyWith(
            color: _getContentColor(isDisabled),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: content,
    );
  }

  Color _getContentColor(bool isDisabled) {
    if (isDisabled) {
      return AppColors.textDisabled;
    }

    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.gradient:
        return widget.textColor ?? AppColors.textLight;
      case ButtonType.secondary:
        return widget.textColor ?? AppColors.primary;
      case ButtonType.glass:
        return widget.textColor ?? AppColors.textPrimary;
      case ButtonType.outline:
      case ButtonType.text:
        return widget.textColor ?? AppColors.primary;
    }
  }

  Color _getLoadingColor(bool isDisabled) {
    if (isDisabled) {
      return AppColors.textDisabled;
    }

    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.gradient:
        return AppColors.textLight;
      case ButtonType.secondary:
        return AppColors.primary;
      case ButtonType.glass:
        return AppColors.textPrimary;
      case ButtonType.outline:
      case ButtonType.text:
        return AppColors.primary;
    }
  }
}

// Specialized button variants for common use cases
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool enableGlow;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.enableGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      type: ButtonType.gradient,
      enableGlow: enableGlow,
      customGradient: AppColors.primaryGlowGradient,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      type: ButtonType.outline,
    );
  }
}

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      type: ButtonType.glass,
      enableShadow: true,
    );
  }
}
