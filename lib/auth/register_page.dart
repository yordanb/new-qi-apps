//kode ke-2
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:android_id/android_id.dart';
import 'package:new_qi_apps/auth/login_page.dart';
import '../component/my_button.dart';
import '../component/my_textfield.dart';
import '../config/config.dart';
import '../pages/mainMenu.dart';
import 'package:flutter/services.dart'; // Import clipboard

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nrpController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final defPasswordController = TextEditingController();
  bool _isPasswordVisible = false; // Untuk mengatur visibilitas password

  // Fungsi untuk mendapatkan Android ID
  Future<String?> _getAndroidId() async {
    const androidIdPlugin = AndroidId();
    return await androidIdPlugin.getId();
  }

  Future<void> signUpUser(BuildContext context) async {
    final String nrp = nrpController.text;
    final String name = nameController.text;
    final String password = passwordController.text;
    final String defPassword = defPasswordController.text;

    // Validasi input
    if (nrp.isEmpty ||
        name.isEmpty ||
        password.isEmpty ||
        defPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi!')),
      );
      return;
    }

    // Get Android ID
    const androidIdPlugin = AndroidId();
    String? androidID = await androidIdPlugin.getId();

    // Prepare data to be sent in JSON format
    final Map<String, dynamic> data = {
      'nrp': nrp,
      'name': name,
      'password': password,
      'def_password': defPassword,
      'androidID': androidID,
    };

    const String apiUrl = "http://$apiIP:$apiPort/auth/reg";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'already_registered') {
          // Handle case where Android ID is already registered
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perangkat sudah terdaftar!')),
          );
          Navigator.pushReplacementNamed(
              context, '/login'); // Navigasi ke halaman login
        } else if (responseData['status'] == 'success') {
          // Handle successful registration
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Successful!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            /*
                builder: (context) => const LoginPage(
                      isAlreadyRegistered: true,
                    )),
                    */
          );
        } else {
          // Handle unknown errors
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Failed!')),
          );
        }
      } else {
        // Handle HTTP errors
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Failed!')),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.person_add,
                  size: 90,
                ),
                const SizedBox(height: 30),
                MyTextField(
                  controller: nrpController,
                  hintText: 'NRP',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: defPasswordController,
                  hintText: 'Default Password',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0), // Atur padding horizontal
                  child: TextField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MyButton(
                  onTap: () => signUpUser(context),
                  text: 'Sign Up',
                ),
                const SizedBox(height: 30),
/*
                // Menampilkan Android ID menggunakan FutureBuilder
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
                */
                // Menampilkan Android ID menggunakan FutureBuilder
                FutureBuilder<String?>(
                  future: _getAndroidId(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Tampilkan loading jika belum selesai
                    } else if (snapshot.hasError) {
                      return const Text('Error mendapatkan Android ID');
                    } else {
                      String androidId = snapshot.data ?? "Tidak tersedia";
                      return GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: androidId)); // Salin ke clipboard
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Android ID disalin ke clipboard!')),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Device ID: $androidId',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors
                                  .blue, // Warna teks biru untuk menunjukkan bisa diklik
                              //decoration: TextDecoration
                              //    .underline, // Garis bawah agar terlihat seperti tautan
                            ),
                          ),
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
