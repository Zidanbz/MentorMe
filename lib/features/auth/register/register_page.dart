import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mentorme/app/constants/app_colors.dart';
import 'package:mentorme/app/constants/app_strings.dart';
import 'package:mentorme/features/auth/services/auth_api_service.dart';
import 'package:mentorme/features/auth/Login/login_page.dart';
import 'package:mentorme/features/profile/terms_conditions_page.dart';
import 'package:mentorme/features/profile/privacy_policy_page.dart';
import 'package:mentorme/shared/widgets/custom_button.dart';
import 'package:mentorme/shared/widgets/custom_text_field.dart';
import 'package:mentorme/shared/widgets/enhanced_animations.dart' as enhanced;
import 'package:mentorme/shared/widgets/loading_dialog.dart';
import 'package:mentorme/global/Fontstyle.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final namaTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    namaTextEditingController.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    confirmTextEditingController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: AppStrings.pleaseCompleteAllFields);
      return;
    }

    // Show Terms & Conditions and Privacy Policy popup
    final bool? accepted = await _showTermsAndPrivacyDialog();
    if (accepted != true) {
      return;
    }

    setState(() => _isLoading = true);
    LoadingDialog.show(context, message: AppStrings.registering);

    try {
      final response = await AuthApiService.register(
        fullName: namaTextEditingController.text.trim(),
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
        confirmPassword: confirmTextEditingController.text.trim(),
      );

      LoadingDialog.hide(context);

      if (response.success) {
        Fluttertoast.showToast(msg: AppStrings.registerSuccess);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            enhanced.OptimizedPageRoute(
              child: const LoginPage(),
              transitionType: enhanced.PageTransitionType.slideLeft,
            ),
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: "${AppStrings.registerFailed}: ${response.message}");
      }
    } catch (error) {
      LoadingDialog.hide(context);
      Fluttertoast.showToast(msg: "${AppStrings.registerFailed}: $error");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < 2) {
      return AppStrings.nameMinLength;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < 8) {
      return AppStrings.passwordMinLength;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value != passwordTextEditingController.text) {
      return AppStrings.passwordNotMatch;
    }
    return null;
  }

  Future<bool?> _showTermsAndPrivacyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFe0fff3),
                  Color(0xFF339989),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: const Color(0xFF339989),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Syarat & Ketentuan',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: const Color(0xFF3c493f),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Content
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sebelum mendaftar, Anda perlu menyetujui:',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: const Color(0xFF3c493f),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Terms & Conditions Button
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TermsConditionsPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.description, size: 20),
                          label: const Text('Baca Syarat & Ketentuan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF339989),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),

                      // Privacy Policy Button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicyPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.privacy_tip, size: 20),
                          label: const Text('Baca Kebijakan Privasi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3c493f),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side:
                                const BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF339989),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Saya Setuju',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: const Color(0xFF339989),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(const Color(0xFF339989), const Color(0xFF3c493f),
                      _backgroundAnimation.value)!,
                  Color.lerp(const Color(0xFF3c493f), const Color(0xFFe0fff3),
                      _backgroundAnimation.value)!,
                  Color.lerp(const Color(0xFFe0fff3), const Color(0xFF339989),
                      _backgroundAnimation.value)!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: enhanced.OptimizedStaggeredList(
                          duration: const Duration(milliseconds: 800),
                          staggerDelay: const Duration(milliseconds: 120),
                          children: [
                            const SizedBox(height: 20),

                            // Logo with enhanced animation
                            enhanced.OptimizedScale(
                              duration: const Duration(milliseconds: 1200),
                              curve: Curves.elasticOut,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const RadialGradient(
                                    colors: [
                                      Color(0xFFe0fff3),
                                      Color(0xFF339989),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF339989)
                                          .withOpacity(0.4),
                                      blurRadius: 25,
                                      spreadRadius: 8,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/Logo.png',
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // App Name with gradient text
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF339989), Color(0xFF3c493f)],
                              ).createShader(bounds),
                              child: Text(
                                AppStrings.appName,
                                style: AppTextStyles.displaySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Title with enhanced styling
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF339989),
                                    Color(0xFF3c493f)
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF339989)
                                        .withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                AppStrings.register,
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Subtitle
                            Text(
                              'Bergabunglah dengan komunitas belajar!',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: const Color(0xFF3c493f),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),

                            // Name Field with enhanced styling
                            enhanced.OptimizedFadeSlide(
                              delay: const Duration(milliseconds: 200),
                              child: CustomTextField(
                                controller: namaTextEditingController,
                                hintText: AppStrings.fullName,
                                prefixIcon: Icons.person_outline,
                                validator: _validateName,
                                enabled: !_isLoading,
                                enableGlow: true,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Email Field with enhanced styling
                            enhanced.OptimizedFadeSlide(
                              delay: const Duration(milliseconds: 300),
                              child: EmailTextField(
                                controller: emailTextEditingController,
                                hintText: AppStrings.email,
                                validator: _validateEmail,
                                enabled: !_isLoading,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Password Field with enhanced styling
                            enhanced.OptimizedFadeSlide(
                              delay: const Duration(milliseconds: 400),
                              child: PasswordTextField(
                                controller: passwordTextEditingController,
                                hintText: AppStrings.password,
                                validator: _validatePassword,
                                enabled: !_isLoading,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password Field with enhanced styling
                            enhanced.OptimizedFadeSlide(
                              delay: const Duration(milliseconds: 500),
                              child: PasswordTextField(
                                controller: confirmTextEditingController,
                                hintText: AppStrings.confirmPassword,
                                validator: _validateConfirmPassword,
                                enabled: !_isLoading,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Register Button with enhanced styling
                            enhanced.OptimizedFadeSlide(
                              delay: const Duration(milliseconds: 600),
                              child: enhanced.OptimizedHover(
                                scale: 1.03,
                                child: Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF339989),
                                        Color(0xFF3c493f)
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF339989)
                                            .withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: _isLoading ? null : _registerUser,
                                      child: Center(
                                        child: _isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Text(
                                                AppStrings.registerButton,
                                                style: AppTextStyles.labelLarge
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Divider with gradient
                            enhanced.OptimizedFadeSlide(
                              delay: const Duration(milliseconds: 700),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Color(0xFF339989),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'atau',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: const Color(0xFF3c493f),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Color(0xFF339989),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Login Link with enhanced styling
                            enhanced.OptimizedFadeSlide(
                              delay: const Duration(milliseconds: 800),
                              child: enhanced.OptimizedHover(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFe0fff3)
                                        .withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF339989)
                                          .withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF339989)
                                            .withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppStrings.alreadyHaveAccount,
                                        style:
                                            AppTextStyles.bodyMedium.copyWith(
                                          color: const Color(0xFF3c493f),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: _isLoading
                                            ? null
                                            : () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  enhanced.OptimizedPageRoute(
                                                    child: const LoginPage(),
                                                    transitionType: enhanced
                                                        .PageTransitionType
                                                        .slideLeft,
                                                  ),
                                                );
                                              },
                                        child: ShaderMask(
                                          shaderCallback: (bounds) =>
                                              const LinearGradient(
                                            colors: [
                                              Color(0xFF339989),
                                              Color(0xFF3c493f)
                                            ],
                                          ).createShader(bounds),
                                          child: Text(
                                            AppStrings.loginHere,
                                            style: AppTextStyles.labelLarge
                                                .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
