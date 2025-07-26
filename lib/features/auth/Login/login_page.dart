import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mentorme/app/constants/app_colors.dart';
import 'package:mentorme/app/constants/app_strings.dart';
import 'package:mentorme/core/services/auth_services.dart';
import 'package:mentorme/core/storage/storage_service.dart';
import 'package:mentorme/features/auth/register/register_page.dart';
import 'package:mentorme/shared/widgets/custom_button.dart';
import 'package:mentorme/shared/widgets/custom_text_field.dart';
import 'package:mentorme/shared/widgets/loading_dialog.dart';
import 'package:mentorme/global/global.dart';
import 'package:mentorme/mainScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
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

      final responseData = await AuthService.login(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
        fcmToken: fcmToken,
      );

      final token = responseData['data']['token'] as String;
      currentUserToken = token;

      final nameUser = responseData['data']['nameUser'] as String? ?? '';
      final emailUser = responseData['data']['email'] as String? ?? '';

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
      final categories = responseData['data']['categories'] != null
          ? List<Map<String, dynamic>>.from(responseData['data']['categories'])
          : <Map<String, dynamic>>[];

      final learningPaths = responseData['data']['learningPath'] != null
          ? List<Map<String, dynamic>>.from(
              responseData['data']['learningPath'])
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
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/Logo.png',
                        width: 200,
                        height: 200,
                      ),

                      // Title
                      Text(
                        AppStrings.login,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email Field
                      CustomTextField(
                        controller: emailTextEditingController,
                        hintText: AppStrings.email,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        validator: _validateEmail,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      CustomTextField(
                        controller: passwordTextEditingController,
                        hintText: AppStrings.password,
                        obscureText: true,
                        prefixIcon: Icons.security,
                        validator: _validatePassword,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      CustomButton(
                        text: AppStrings.loginButton,
                        onPressed: _isLoading ? null : _loginUser,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 20),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.dontHaveAccount,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage(),
                                      ),
                                    );
                                  },
                            child: Text(
                              AppStrings.registerHere,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
