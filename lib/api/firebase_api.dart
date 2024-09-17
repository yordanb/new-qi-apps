import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:new_qi_apps/main.dart';
import '../auth/db_service.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      // Inisialisasi DBService untuk SharedPreferences
      await DBService.init();

      // Meminta izin untuk notifikasi
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        if (kDebugMode) {
          //print("User denied notification permission");
        }
        return;
      }

      // Mendapatkan token FCM
      final fCMToken = await _firebaseMessaging.getToken();

      if (fCMToken == null) {
        if (kDebugMode) {
          //print("Failed to obtain FCM Token: Token is null");
        }
        return;
      }

      // Menyimpan token ke DBService
      await DBService.set("fCMToken", fCMToken);
      if (kDebugMode) {
        //print("Token saved successfully: $fCMToken");
      }

      // Inisialisasi push notifications
      initPushNotifications();
    } catch (e) {
      if (kDebugMode) {
        //print("Failed to initialize notifications: $e");
      }
    }
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState
        ?.pushNamed('/notification_screen', arguments: message);
  }

  Future<void> initPushNotifications() async {
    try {
      FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

      if (kDebugMode) {
        //print("Push notifications initialized successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        //print("Failed to initialize push notifications: $e");
      }
    }
  }
}
