import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mentorme/Pages/Beranda/beranda.dart';
import 'package:mentorme/Pages/Daftar/daftar_page.dart';
import 'package:mentorme/global/Fontstyle.dart';
import 'package:mentorme/global/global.dart';
import 'package:mentorme/mainScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFFE0FFF3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/Logo.png',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.green),
                    const SizedBox(width: 15),
                    const Text(
                      "Sedang masuk...",
                      style: Subjudulstyle.defaultTextStyle,
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

  void hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      showLoadingDialog();

      try {
        final response = await http.post(
          Uri.parse('https://widgets-catb7yz54a-uc.a.run.app/api/login/user'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': emailTextEditingController.text.trim(),
            'password': passwordTextEditingController.text.trim(),
          }),
        );

        final responseData = json.decode(response.body);

        hideLoadingDialog();

        if (response.statusCode == 200) {
          String token = responseData['data']['token'];
          currentUserToken = token;

          // Validasi categories dan learningPaths agar tidak null
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
        } else {
          String errorMessage = responseData['error'] ?? "Terjadi kesalahan.";
          Fluttertoast.showToast(msg: errorMessage);
        }
      } catch (error) {
        hideLoadingDialog();
        Fluttertoast.showToast(msg: "Gagal login: $error");
      }
    } else {
      Fluttertoast.showToast(msg: "Mohon isi semua data dengan benar");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0FFF3),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                const Text('MentorME', style: judulstyle.defaultTextStyle),
                const SizedBox(height: 10),
                const Text('Login', style: Subjudulstyle.defaultTextStyle),
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
                    if (text == null || text.isEmpty) {
                      return 'Tidak boleh kosong';
                    }
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
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                const Text(
                  'Or social login',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Aksi login dengan Google
                      },
                      icon: Image.asset(
                        'assets/google.png',
                        width: 27,
                        height: 27,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF339989),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun?',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar di sini',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF339989),
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
    );
  }
}
