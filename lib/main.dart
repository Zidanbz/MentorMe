import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mentorme/features/auth/Login/login_page.dart';
import 'package:mentorme/providers/getProject_provider.dart';
import 'package:mentorme/providers/project_provider.dart';
import 'package:mentorme/splash_screen.dart';
import 'package:mentorme/utils/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init(); // 🔥 Setup Notification Service

  // Dapatkan token FCM
  String? token = await FirebaseMessaging.instance.getToken();
  print("🔥 FCM Token: $token");

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
  late FirebaseMessaging _firebaseMessaging;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    _firebaseMessaging = FirebaseMessaging.instance;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Inisialisasi notifikasi lokal
    _initializeNotifications();

    // Mengatur callback untuk notifikasi saat aplikasi aktif
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Notifikasi diterima di foreground: ${message.notification?.title}');
      _showNotification(message);
    });

    // Ambil token FCM
    _getToken();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: IOSInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Menampilkan notifikasi lokal
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("🔥 FCM Token: $token");
  }

  // Fungsi pengecekan status aplikasi
  Future<Map<String, dynamic>> _checkAppStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
    }

    return {
      'firstLaunch': isFirstLaunch,
      'isLoggedIn': isLoggedIn,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _checkAppStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final isFirstLaunch = snapshot.data?['firstLaunch'] ?? true;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'OpenSans',
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          home: isFirstLaunch ? SplashScreen() : const LoginPage(),
        );
      },
    );
  }
}
