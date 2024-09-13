import 'package:flutter/material.dart';
import 'package:new_qi_apps/auth/db_service.dart';
//import 'package:new_qi_apps/pages/home.dart';
//import 'package:new_qi_apps/pages/mainMenu.dart';

import 'animation/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    );
  }
}
