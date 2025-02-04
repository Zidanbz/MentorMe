import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mentorme/Pages/Kegiatanku/detail_kegiatan.dart';
import 'package:mentorme/Pages/Kegiatanku/kegiatanku.dart';
import 'package:mentorme/Pages/Konsultasi/konsultasi.dart';
import 'package:mentorme/Pages/Konsultasi/roomchat.dart';
import 'package:mentorme/Pages/Profile/edit_profile.dart';
import 'package:mentorme/Pages/Profile/profile.dart';
import 'package:mentorme/Pages/Projectku/project_marketplace.dart';
import 'package:mentorme/Pages/detail-project/detail-project.dart';
import 'package:mentorme/Pages/notifications/notifications.dart';
import 'package:mentorme/Pages/topup/historytopup.dart';
import 'package:mentorme/Pages/topup/topupcoin.dart';
import 'package:mentorme/providers/getProject_provider.dart';
import 'package:provider/provider.dart';
import 'package:mentorme/Pages/Login/login_page.dart';
import 'package:mentorme/mainScreen.dart';
import 'package:mentorme/splash_screen.dart';
import 'package:mentorme/providers/project_provider.dart'; // Tambahkan ini
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      // Wrap dengan MultiProvider
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
      home: SplashScreen(),
    );
  }
}
