//kode ke-1

import 'package:flutter/material.dart';
import '../auth/db_service.dart';
import 'page_menu_sap.dart'; // Pastikan ini mengarah ke file yang benar
import 'page_menu_ss.dart';
import 'page_menu_ipeak.dart';
import 'page_menu_jarvis.dart';
import 'page_menu_ssab.dart';
import '../auth/login_page.dart'; // Sesuaikan dengan path halaman login

// Ambil token yang disimpan

class CardExample extends StatefulWidget {
  const CardExample({super.key});

  @override
  _CardExampleState createState() => _CardExampleState();
}

class _CardExampleState extends State<CardExample> {
  bool _isDarkMode = false; // Variabel untuk dark mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              setState(() {
                _isDarkMode =
                    !_isDarkMode; // Toggle antara dark mode dan light mode
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(10),
              children: [
                _buildCard(context, 'SS', const PageSS()),
                _buildCard(context, 'SAP', const PageMenuSAP()),
                _buildCard(context, 'Ipeak', const PageIpeak()),
                _buildCard(context, 'Jarvis', const PageJarvis()),
                _buildCard(context, 'SS AB', const PageSSAB()),
                _buildCard(context, 'KPI QI', const PageSSAB()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment:
                  Alignment.bottomRight, // Tempatkan tombol di kanan bawah
              child: ElevatedButton(
                onPressed: () {
                  // Fungsi logout: Kembali ke halaman login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginPage()), // Arahkan ke halaman login
                  );
                },
                child: const Text('Logout'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget page) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false; // Variabel untuk dark mode

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Tema terang
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Tema gelap
      ),
      home: const CardExample(), // Panggil CardExample
    );
  }

  // Function untuk toggle dark mode
  void toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  String? getToken() {
    return DBService.get("token");
  }
}

void main() {
  runApp(MyApp());
}
