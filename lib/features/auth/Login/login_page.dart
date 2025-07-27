import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mentorme/app/constants/app_strings.dart';
import 'package:mentorme/features/auth/services/auth_api_service.dart';
import 'package:mentorme/core/storage/storage_service.dart';
import 'package:mentorme/features/auth/register/register_page.dart';
import 'package:mentorme/shared/widgets/loading_dialog.dart';
import 'package:mentorme/global/global.dart';
import 'package:mentorme/global/Fontstyle.dart';
import 'package:mentorme/mainScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  // Enhanced color palette
  static const Color primaryColor = Color(0xFF339989);
  static const Color darkTextColor = Color(0xFF3C493F);
  static const Color backgroundColor = Color(0xFFE0FFF3);

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Animation controllers
  late AnimationController _backgroundController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  late Animation<double> _backgroundAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _floatingAnimation = Tween<double>(
      begin: -20.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    _backgroundController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: AppStrings.pleaseCompleteAllFields);
      return;
    }

    setState(() => _isLoading = true);
    LoadingDialog.show(context, message: AppStrings.loggingIn);

    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      final response = await AuthApiService.login(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
        fcmToken: fcmToken,
      );

      if (response.success && response.data != null) {
        final responseData = response.data!;
        final token = responseData['token'] as String;
        currentUserToken = token;

        final nameUser = responseData['nameUser'] as String? ?? '';
        final emailUser = responseData['email'] as String? ?? '';

        // Save user data using our storage service
        final storage = await SharedPreferencesService.getInstance();
        await storage.saveUserToken(token);
        await storage.saveUserData(
          name: nameUser,
          email: emailUser,
          password: passwordTextEditingController.text.trim(),
        );
        await storage.setLoggedIn(true);

        // Update Firebase user display name
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null && nameUser.isNotEmpty) {
          await firebaseUser.updateDisplayName(nameUser);
          await firebaseUser.reload();
        }

        // Parse categories and learning paths
        final categories = responseData['categories'] != null
            ? List<Map<String, dynamic>>.from(responseData['categories'])
            : <Map<String, dynamic>>[];

        final learningPaths = responseData['learningPath'] != null
            ? List<Map<String, dynamic>>.from(responseData['learningPath'])
            : <Map<String, dynamic>>[];

        // Save additional data
        await storage.setString('categories', categories.toString());
        await storage.setString('learningPaths', learningPaths.toString());

        LoadingDialog.hide(context);
        Fluttertoast.showToast(msg: AppStrings.loginSuccess);

        // Navigate to main screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(
                categories: categories,
                learningPaths: learningPaths,
              ),
            ),
          );
        }
      } else {
        LoadingDialog.hide(context);
        Fluttertoast.showToast(
            msg: "${AppStrings.loginFailed}: ${response.message}");
      }
    } catch (error) {
      LoadingDialog.hide(context);
      Fluttertoast.showToast(msg: "${AppStrings.loginFailed}: $error");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
    return null;
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
                  Color.lerp(backgroundColor, primaryColor,
                      _backgroundAnimation.value * 0.3)!,
                  Color.lerp(primaryColor, backgroundColor,
                      _backgroundAnimation.value * 0.5)!,
                  Color.lerp(backgroundColor, darkTextColor,
                      _backgroundAnimation.value * 0.2)!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                _buildFloatingElements(),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildLogo(),
                                const SizedBox(height: 40),
                                _buildTitle(),
                                const SizedBox(height: 40),
                                _buildEmailField(),
                                const SizedBox(height: 20),
                                _buildPasswordField(),
                                const SizedBox(height: 40),
                                _buildLoginButton(),
                                const SizedBox(height: 30),
                                _buildDivider(),
                                const SizedBox(height: 30),
                                _buildRegisterLink(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 100 + _floatingAnimation.value,
              right: 30,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.login,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Positioned(
              top: 200 - _floatingAnimation.value * 0.5,
              left: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.security,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            Positioned(
              bottom: 150 + _floatingAnimation.value * 0.8,
              right: 50,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Image.asset(
              'assets/Logo.png',
              width: 120,
              height: 120,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, backgroundColor],
          ).createShader(bounds),
          child: Text(
            'Masuk',
            style: AppTextStyles.displayMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                const Shadow(
                  blurRadius: 8.0,
                  color: Colors.black26,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selamat datang kembali!',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: emailTextEditingController,
        keyboardType: TextInputType.emailAddress,
        enabled: !_isLoading,
        validator: _validateEmail,
        style: AppTextStyles.bodyMedium.copyWith(
          color: darkTextColor,
        ),
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: darkTextColor.withOpacity(0.6),
          ),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: primaryColor,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: passwordTextEditingController,
        obscureText: _obscurePassword,
        enabled: !_isLoading,
        validator: _validatePassword,
        style: AppTextStyles.bodyMedium.copyWith(
          color: darkTextColor,
        ),
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: darkTextColor.withOpacity(0.6),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: primaryColor,
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: primaryColor,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, darkTextColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isLoading ? null : _loginUser,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.login,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Masuk',
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'atau',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Belum punya akun? ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: darkTextColor.withOpacity(0.8),
            ),
          ),
          GestureDetector(
            onTap: _isLoading
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [primaryColor, darkTextColor],
              ).createShader(bounds),
              child: Text(
                'Daftar di sini',
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
