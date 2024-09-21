//kode ke-2
import 'package:new_qi_apps/pages/mainMenu.dart'; // Import untuk AndroidID
import '../component/my_button.dart';
import '../component/my_textfield.dart';
import 'auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'db_service.dart';
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
    text: kDebugMode ? "5005" : "",
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? "5005" : "",
  );

  String androidID = ""; // Variabel untuk menyimpan AndroidID
  String? fcmToken = "";
  String buttonText = 'Login'; // Variabel untuk menyimpan teks tombol
  bool isPressed = false;
  bool stateLoginAs = false;

  @override
  void initState() {
    super.initState();
    if (widget.isAlreadyRegistered == false) _getAndroidID();
    DBService.init();
    _loadFCMToken(); // Load FCM Token ketika halaman login diinisialisasi
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
        MaterialPageRoute(builder: (context) => const RegisterPage()),
      );
    }
  }

  // Fungsi untuk load FCM Token dari DBService
  Future<void> _loadFCMToken() async {
    setState(() {
      fcmToken = DBService.get("fCMToken");
    });
  }

  // Fungsi untuk melakukan login dengan NRP, password, androidId, dan loginAs
  Future<void> signUserIn(BuildContext context, {required stateLoginAs}) async {
    final nrp = nrpController.text;
    final password = passwordController.text;
    //bool stateLoginAs = false;

    try {
      await AuthService().loginWithNRP(
        nrp: nrp,
        password: password,
        androidId: androidID,
        loginAs: stateLoginAs, // Tambahkan loginAs ke request
      );

      // Simpan NRP
      DBService.set("nrp", nrp);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CardExample()),
      );
    } on Exception catch (_) {
      showDialog(
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

  // Fungsi untuk mengubah teks tombol setelah ditekan 5 detik
  void onLongPress() {
    setState(() {
      buttonText = 'Login as';
    });
  }

  void onLongPressEnd(LongPressEndDetails details) {
    setState(() {
      buttonText = 'Login'; // Kembali ke teks awal setelah tombol dilepas
    });
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
                const SizedBox(height: 150),
                const Icon(
                  Icons.lock,
                  size: 90,
                ),
                const SizedBox(height: 30),
                Text(
                  'Welcome back Innovator, you\'ve been missed!',
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

                // GestureDetector untuk menangani long press
                /*
                GestureDetector(
                  onLongPress: () {
                    Future.delayed(const Duration(seconds: 5), () {
                      if (isPressed) {
                        onLongPress(); // Mengubah teks setelah 5 detik
                      }
                    });
                  },
                  onLongPressStart: (details) {
                    setState(() {
                      isPressed = true;
                    });
                  },
                  onLongPressEnd:
                      onLongPressEnd, // Kembali ke "Login" setelah tombol dilepas
                  child: MyButton(
                    onTap: () {
                      if (buttonText == 'Login') {
                        // Login biasa
                        signUserIn(context, stateLoginAs: false);
                      } else {
                        // Login as
                        signUserIn(context, stateLoginAs: true);
                      }
                    },
                    text: buttonText,
                  ),
                ),
                */
                // GestureDetector untuk menangani long press
                GestureDetector(
                  onLongPress: () {
                    Future.delayed(const Duration(seconds: 5), () {
                      if (isPressed) {
                        onLongPress(); // Mengubah teks menjadi 'Login as' setelah 5 detik
                      }
                    });
                  },
                  onLongPressStart: (details) {
                    setState(() {
                      isPressed = true;
                    });
                  },
                  onLongPressEnd: (details) {
                    setState(() {
                      isPressed = false;
                    });
                  },
                  child: MyButton(
                    onTap: () {
                      if (buttonText == 'Login') {
                        // Login biasa
                        signUserIn(context, stateLoginAs: false);
                      } else {
                        // Login as
                        signUserIn(context, stateLoginAs: true);
                      }
                    },
                    text: buttonText,
                  ),
                ),

                const SizedBox(height: 5),
                FutureBuilder<String?>(
                  future: _getAndroidId(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
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
                const SizedBox(height: 130), // Space before the support text
                const Text(
                  'Supported by QI Agent Plant 2 KIDE',
                  style: TextStyle(
                    color: Colors.blue, // Set the text color to blue
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
