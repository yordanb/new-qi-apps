/*
import 'package:belajar_api_http/main.dart';
import 'package:belajar_api_http/service/auth_service/auth_service.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';

import 'package:belajar_api_http/components/my_button.dart';
import 'package:belajar_api_http/components/my_textfield.dart';
//import 'package:belajar_api_http/components/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController(
    text: kDebugMode ? "admin@demo.com" : "",
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? "123456" : "",
  );

  Future<void> signUserIn(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;
    //print(usernameController);

    try {
      await AuthService().loginWithEmail(
        email: username,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );

      // if (isAdmin) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const MyHomePage()),
      //   );
      // } else if (isSpv) {
      //   //Navigasi ke menu SPV
      // } else if (isStaff) {
      //   //Navigasi ke menu Staff
      // }
    } on Exception catch (_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid username or password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 90,
                ),
                const SizedBox(height: 30),
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                MyButton(
                  onTap: () => signUserIn(context),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SquareTile(imagePath: 'assets/images/google.png'),
                    SizedBox(width: 15),
                    // SquareTile(imagePath: 'assets/images/apple.png')
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

*/

/*
import 'package:new_qi_apps/pages/mainMenu.dart';

import '../component/my_button.dart';
import '../component/my_textfield.dart';
import 'auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'register_page.dart'; // Import halaman registrasi

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController(
    text: kDebugMode ? "admin@demo.com" : "",
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? "123456" : "",
  );

  Future<void> signUserIn(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    try {
      await AuthService().loginWithEmail(
        email: username,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CardExample()),
      );
    } on Exception catch (_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid username or password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 90,
                ),
                const SizedBox(height: 30),
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                MyButton(
                  onTap: () => signUserIn(context),
                  text: '',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/

import 'package:new_qi_apps/pages/mainMenu.dart'; // Import untuk AndroidID
import '../component/my_button.dart';
import '../component/my_textfield.dart';
import 'auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'register_page.dart'; // Import halaman registrasi
import 'package:android_id/android_id.dart';

class LoginPage extends StatefulWidget {
  final bool isAlreadyRegistered;
  const LoginPage({
    super.key,
    this.isAlreadyRegistered = false,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nrpController = TextEditingController(
    text: kDebugMode ? "12345678" : "",
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? "123456" : "",
  );

  String androidID = ""; // Variabel untuk menyimpan AndroidID

  @override
  void initState() {
    super.initState();
    if (widget.isAlreadyRegistered == false) _getAndroidID();
  }

// Mendapatkan AndroidID perangkat menggunakan android_id plugin
  Future<void> _getAndroidID() async {
    const androidIdPlugin = AndroidId();
    String? androidID = await androidIdPlugin.getId(); // Mendapatkan AndroidID

    setState(() {
      this.androidID = androidID!; // Simpan AndroidID
    });

    // Cek apakah AndroidID sudah terdaftar
    bool isRegistered = await AuthService().checkAndroidID(androidID!);
    if (!isRegistered) {
      // Jika AndroidID belum terdaftar, arahkan ke halaman registrasi
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    }
  }

  // Fungsi untuk melakukan login dengan NRP, password, dan AndroidID
  Future<void> signUserIn(BuildContext context) async {
    final nrp = nrpController.text;
    final password = passwordController.text;

    try {
      await AuthService().loginWithNRP(
        nrp: nrp,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CardExample()),
      );
    } on Exception catch (_) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid NRP or password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<String?> _getAndroidId() async {
    const androidIdPlugin = AndroidId();
    return await androidIdPlugin.getId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 90,
                ),
                const SizedBox(height: 30),
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: nrpController,
                  hintText: 'NRP',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                MyButton(
                  onTap: () => signUserIn(context),
                  text: 'Login',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder<String?>(
                  future: _getAndroidId(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Tampilkan loading jika belum selesai
                    } else if (snapshot.hasError) {
                      return const Text('Error mendapatkan Android ID');
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Device ID: ${snapshot.data ?? "Tidak tersedia"}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
