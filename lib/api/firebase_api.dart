import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:new_qi_apps/main.dart';
import '../auth/db_service.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    try {
      // Save the token to the DBService
      await DBService.set("fCMToken", fCMToken!);
      if (kDebugMode) {
        print("Token saved successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to save token: $e");
      }
    }

    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState
        ?.pushNamed('/notification_screen', arguments: message);
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
