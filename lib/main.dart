import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mentorme/dft.dart';
import 'package:mentorme/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum Role { trainee, mentor }

Role _userRole = Role.trainee;

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  Role _userRole = Role.trainee; // Inisialisasi peran

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SFPro',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      home: const RegisterPage(),
    );
  }
}
