import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mentorme/core/services/auth_services.dart';
import 'package:mentorme/features/auth/register/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

import 'package:mentorme/global/Fontstyle.dart';
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
  final LocalAuthentication auth = LocalAuthentication();
  bool _passwordVisible = false;

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFFE0FFF3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/Logo.png', width: 60, height: 60),
                const SizedBox(height: 15),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.green),
                    const SizedBox(width: 15),
                    const Text("Sedang masuk...",
                        style: Subjudulstyle.defaultTextStyle),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      showLoadingDialog();
      try {
        final fcmToken = await FirebaseMessaging.instance.getToken();

        final responseData = await AuthService.login(
          email: emailTextEditingController.text,
          password: passwordTextEditingController.text,
          fcmToken: fcmToken,
        );

        hideLoadingDialog();

        String token = responseData['data']['token'];
        currentUserToken = token;

        String nameUser = responseData['data']['nameUser'] ?? '';
        String emailUser = responseData['data']['email'] ?? '';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nameUser', nameUser);
        await prefs.setString('emailUser', emailUser);
        await prefs.setString(
            'passwordUser', passwordTextEditingController.text.trim());
          await prefs.setBool('isLoggedIn', true);
        print('🔥 isLoggedIn set ke true');

        

        User? firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null && nameUser.isNotEmpty) {
          await firebaseUser.updateDisplayName(nameUser);
          await firebaseUser.reload();
          print('✅ Display name diperbarui: $nameUser');
        }

        List<Map<String, dynamic>> categories =
            responseData['data']['categories'] != null
                ? List<Map<String, dynamic>>.from(
                    responseData['data']['categories'])
                : [];

        List<Map<String, dynamic>> learningPaths =
            responseData['data']['learningPath'] != null
                ? List<Map<String, dynamic>>.from(
                    responseData['data']['learningPath'])
                : [];
              // Menyimpan ke SharedPreferences
        await prefs.setString('categories', categories.toString());
        await prefs.setString('learningPaths', learningPaths.toString());

        
        Fluttertoast.showToast(msg: "Login berhasil");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (c) => MainScreen(
              categories: categories,
              learningPaths: learningPaths,
            ),
          ),
        );
      } catch (error) {
        hideLoadingDialog();
        Fluttertoast.showToast(msg: "Gagal login: $error");
      }
    } else {
      Fluttertoast.showToast(msg: "Mohon isi semua data dengan benar");
    }
  }

  Future<void> _loginWithFingerprint() async {
    try {
      final isSupported = await auth.isDeviceSupported();
      final canCheckBiometrics = await auth.canCheckBiometrics;

      if (!isSupported || !canCheckBiometrics) {
        Fluttertoast.showToast(msg: "Perangkat tidak mendukung biometrik");
        return;
      }

      final isAuthenticated = await auth.authenticate(
        localizedReason: 'Gunakan sidik jari untuk masuk',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        final prefs = await SharedPreferences.getInstance();
        String? savedEmail = prefs.getString('emailUser');
        String? savedPassword = prefs.getString('passwordUser');
        prefs.setBool('isLoggedIn', true);
        print('🔥 isLoggedIn set ke true');

        if (savedEmail != null && savedPassword != null) {
          emailTextEditingController.text = savedEmail;
          passwordTextEditingController.text = savedPassword;
          await loginUser();
        } else {
          Fluttertoast.showToast(msg: "Data login tidak ditemukan");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Autentikasi gagal: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0FFF3),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
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
                    Image.asset('assets/Logo.png', width: 200, height: 200),
                    const Text('LOGIN', style: Subjudulstyle.defaultTextStyle),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: emailTextEditingController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: Captionsstyle.defaultTextStyle,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (text) {
                        if (text == null || text.isEmpty)
                          return 'Tidak boleh kosong';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordTextEditingController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: Captionsstyle.defaultTextStyle,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.security),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(
                              () => _passwordVisible = !_passwordVisible),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (text) {
                        if (text == null || text.isEmpty)
                          return 'Tidak boleh kosong';
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF339989),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      child: const Text('Masuk',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Belum punya akun?',
                            style: TextStyle(fontSize: 16)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text('Daftar di sini',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF339989))),
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
    );
  }
}
