import 'package:flutter/material.dart';
import 'package:new_qi_apps/api/firebase_api.dart';
import 'package:new_qi_apps/auth/db_service.dart';
import 'package:new_qi_apps/firebase_options.dart';
import 'package:new_qi_apps/pages/page_firebase_notification.dart';
//import 'package:new_qi_apps/pages/home.dart';
//import 'package:new_qi_apps/pages/mainMenu.dart';

import 'animation/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  await DBService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashPage(),
      navigatorKey: navigatorKey,
      routes: {'/notification_screen': (context) => const NotificationPage()},
    );
  }
}
