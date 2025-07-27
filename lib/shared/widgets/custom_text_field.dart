import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentorme/app/constants/app_colors.dart';
import 'package:mentorme/global/Fontstyle.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final VoidCallback? onSuffixIconPressed;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final bool autofocus;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final Color? borderColor;
  final bool enableFloatingLabel;
  final bool enableShadow;
  final bool enableGlow;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.suffixWidget,
    this.onSuffixIconPressed,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.autofocus = false,
    this.borderRadius = 16,
    this.padding,
    this.fillColor,
    this.borderColor,
    this.enableFloatingLabel = true,
    this.enableShadow = false,
    this.enableGlow = false,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _glowAnimation;

  late FocusNode _focusNode;
  late bool _obscureText;
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _borderColorAnimation = ColorTween(
      begin: widget.borderColor ?? AppColors.border,
      end: AppColors.primary,
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

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _animationController.forward();
      if (widget.enableGlow) {
        HapticFeedback.selectionClick();
      }
    } else {
      _animationController.reverse();
    }
  }

  void _onChanged(String value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() {
        _hasError = error != null;
        _errorText = error;
      });
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: _buildContainerDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.labelText != null && !widget.enableFloatingLabel)
                _buildLabel(),
              _buildTextField(),
              if (_hasError && _errorText != null) _buildErrorText(),
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _buildContainerDecoration() {
    List<BoxShadow> shadows = [];

    if (widget.enableShadow) {
      shadows.add(
        BoxShadow(
          color: AppColors.shadowLight,
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      );
    }

    if (widget.enableGlow && _isFocused) {
      shadows.add(
        BoxShadow(
          color: AppColors.primary.withOpacity(0.2 * _glowAnimation.value),
          offset: const Offset(0, 0),
          blurRadius: 12 * _glowAnimation.value,
          spreadRadius: 2 * _glowAnimation.value,
        ),
      );
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: shadows,
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        widget.labelText!,
        style: AppTextStyles.labelMedium.copyWith(
          color: _hasError
              ? AppColors.error
              : (_isFocused ? AppColors.primary : AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onTap: widget.onTap,
      onChanged: _onChanged,
      onFieldSubmitted: widget.onSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: AppTextStyles.bodyMedium.copyWith(
        color: widget.enabled ? AppColors.textPrimary : AppColors.textDisabled,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.enableFloatingLabel ? widget.labelText : null,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textHint,
        ),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: _hasError
              ? AppColors.error
              : (_isFocused ? AppColors.primary : AppColors.textHint),
        ),
        floatingLabelStyle: AppTextStyles.labelMedium.copyWith(
          color: _hasError ? AppColors.error : AppColors.primary,
        ),
        prefixIcon: _buildPrefixIcon(),
        suffixIcon: _buildSuffixIcon(),
        filled: true,
        fillColor: widget.fillColor ??
            (widget.enabled
                ? AppColors.backgroundCard
                : AppColors.backgroundSoft),
        border: _buildBorder(AppColors.border),
        enabledBorder: _buildBorder(widget.borderColor ?? AppColors.border),
        focusedBorder: _buildBorder(AppColors.primary),
        errorBorder: _buildBorder(AppColors.error),
        focusedErrorBorder: _buildBorder(AppColors.error),
        disabledBorder: _buildBorder(AppColors.borderLight),
        contentPadding: widget.padding ??
            EdgeInsets.symmetric(
              horizontal:
                  widget.prefixIcon != null || widget.prefixWidget != null
                      ? 12
                      : 20,
              vertical:
                  widget.maxLines != null && widget.maxLines! > 1 ? 16 : 18,
            ),
        counterStyle: AppTextStyles.caption,
        errorStyle: const TextStyle(height: 0), // Hide default error text
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixWidget != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: widget.prefixWidget,
      );
    }

    if (widget.prefixIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Icon(
          widget.prefixIcon,
          color: _hasError
              ? AppColors.error
              : (_isFocused ? AppColors.primary : AppColors.textHint),
          size: 20,
        ),
      );
    }

    return null;
  }

  Widget? _buildSuffixIcon() {
    // Handle password visibility toggle
    if (widget.obscureText) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: _hasError
                ? AppColors.error
                : (_isFocused ? AppColors.primary : AppColors.textHint),
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          splashRadius: 20,
        ),
      );
    }

    if (widget.suffixWidget != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: widget.suffixWidget,
      );
    }

    if (widget.suffixIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: IconButton(
          icon: Icon(
            widget.suffixIcon,
            color: _hasError
                ? AppColors.error
                : (_isFocused ? AppColors.primary : AppColors.textHint),
            size: 20,
          ),
          onPressed: widget.onSuffixIconPressed,
          splashRadius: 20,
        ),
      );
    }

    return null;
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: color,
        width: _isFocused ? 2 : 1,
      ),
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16),
      child: Text(
        _errorText!,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.error,
        ),
      ),
    );
  }
}

// Specialized text field variants
class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final VoidCallback? onClear;

  const SearchTextField({
    super.key,
    required this.controller,
    this.hintText = 'Cari...',
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icons.search,
      suffixWidget: controller.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: () {
                controller.clear();
                onClear?.call();
              },
            )
          : null,
      onChanged: onChanged,
      borderRadius: 25,
      enableShadow: true,
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool enabled;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.hintText = 'Password',
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      obscureText: true,
      prefixIcon: Icons.lock_outline,
      validator: validator,
      enabled: enabled,
      enableGlow: true,
    );
  }
}

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool enabled;

  const EmailTextField({
    super.key,
    required this.controller,
    this.hintText = 'Email',
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email_outlined,
      validator: validator,
      enabled: enabled,
      enableGlow: true,
    );
  }
}
