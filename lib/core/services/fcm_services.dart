// lib/core/service/fcm_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  // Fungsi untuk mendapatkan FCM token
  Future<String> getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (token != null) {
      return token;
    } else {
      throw Exception("Gagal mendapatkan token FCM");
    }
  }
}
