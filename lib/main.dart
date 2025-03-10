import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mentorme/mainScreen.dart';
import 'package:mentorme/providers/getProject_provider.dart';
import 'package:provider/provider.dart';
import 'package:mentorme/splash_screen.dart';
import 'package:mentorme/providers/project_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => GetProjectProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        // Tampilkan loading (SplashScreen) saat status login masih dicek
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        }

        // Jika user sudah login, langsung ke MainScreen, jika tidak tetap di SplashScreen
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'SFPro',
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          home: snapshot.data == true
              ? MainScreen(categories: [], learningPaths: [])
              : SplashScreen(),
        );
      },
    );
  }
}
