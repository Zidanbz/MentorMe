import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mentorme/core/storage/storage_service.dart';
import 'package:mentorme/features/auth/login/login_page.dart';
import 'package:mentorme/providers/getProject_provider.dart';
import 'package:mentorme/providers/project_provider.dart';
import 'package:mentorme/splash_screen.dart';
import 'package:mentorme/utils/notification_service.dart';
import 'package:mentorme/app/constants/app_colors.dart';
import 'package:mentorme/global/Fontstyle.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init(); // 🔥 Setup Notification Service

  // Dapatkan token FCM
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    print("🔥 FCM Token: $token");
  } catch (e) {
    print("⚠️ Gagal ambil FCM Token: $e");
  }

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
    _initializeFirebaseMessaging();
  }

  void _initializeFirebaseMessaging() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Initialize notifications asynchronously to avoid blocking UI
    _initializeNotifications();

    // Set up message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(message);
      }
    });

    // Get FCM token asynchronously
    _getToken();
  }

  void _initializeNotifications() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');
      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  void _showNotification(RemoteMessage message) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'mentorme_channel',
        'MentorMe Notifications',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
      );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  void _getToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("🔥 FCM Token: $token");
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  // Fungsi pengecekan status aplikasi
  Future<Map<String, dynamic>> _checkAppStatus() async {
    final storage = await SharedPreferencesService.getInstance();
    bool isFirstLaunch = await storage.isFirstLaunch();
    bool isLoggedIn = await storage.isLoggedIn();

    if (isFirstLaunch) {
      await storage.setFirstLaunch(false);
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
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.backgroundLight,
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.primaryDark,
              surface: AppColors.surface,
              background: AppColors.backgroundLight,
              error: AppColors.error,
              onPrimary: AppColors.textLight,
              onSecondary: AppColors.textLight,
              onSurface: AppColors.textPrimary,
              onBackground: AppColors.textPrimary,
              onError: AppColors.textLight,
            ),
            textTheme: TextTheme(
              displayLarge: AppTextStyles.displayLarge,
              displayMedium: AppTextStyles.displayMedium,
              displaySmall: AppTextStyles.displaySmall,
              headlineLarge: AppTextStyles.headlineLarge,
              headlineMedium: AppTextStyles.headlineMedium,
              headlineSmall: AppTextStyles.headlineSmall,
              titleLarge: AppTextStyles.titleLarge,
              titleMedium: AppTextStyles.titleMedium,
              titleSmall: AppTextStyles.titleSmall,
              bodyLarge: AppTextStyles.bodyLarge,
              bodyMedium: AppTextStyles.bodyMedium,
              bodySmall: AppTextStyles.bodySmall,
              labelLarge: AppTextStyles.labelLarge,
              labelMedium: AppTextStyles.labelMedium,
              labelSmall: AppTextStyles.labelSmall,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textLight,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textLight,
              ),
              iconTheme: const IconThemeData(color: AppColors.textLight),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                elevation: 4,
                shadowColor: AppColors.shadow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: AppTextStyles.button,
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: AppTextStyles.button,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTextStyles.button,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.backgroundCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              labelStyle: AppTextStyles.labelMedium,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
            cardTheme: const CardThemeData(
              elevation: 2,
              shadowColor: AppColors.shadowLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              margin: EdgeInsets.all(8),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textLight,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColors.surface,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textHint,
              selectedLabelStyle: AppTextStyles.labelSmall,
              unselectedLabelStyle: AppTextStyles.labelSmall,
              type: BottomNavigationBarType.fixed,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              elevation: 8,
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: AppColors.primaryDark,
              contentTextStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              behavior: SnackBarBehavior.floating,
            ),
            dividerTheme: DividerThemeData(
              color: AppColors.divider,
              thickness: 1,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.textSecondary,
              size: 24,
            ),
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: AppColors.primary,
              linearTrackColor: AppColors.divider,
              circularTrackColor: AppColors.divider,
            ),
          ),
          home: isFirstLaunch ? SplashScreen() : const LoginPage(),
        );
      },
    );
  }
}
