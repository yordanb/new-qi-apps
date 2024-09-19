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
  //String? get fcmToken => DBService.get("fCMToken");

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

    //print(androidID);

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
      //print('fcm login :  $fcmToken');
    });
  }

  // Fungsi untuk melakukan login dengan NRP, password, dan AndroidID
  Future<void> signUserIn(BuildContext context) async {
    final nrp = nrpController.text;
    final password = passwordController.text;

    try {
      await AuthService().loginWithNRP(
        nrp: nrp,
        password: password,
        androidId: androidID,
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
    //String? fCMToken = DBService.get("fCMToken");
    //print(fCMToken);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      //backgroundColor: const Color.fromARGB(255, 0, 247, 255),
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
                MyButton(
                  onTap: () => signUserIn(context),
                  text: 'Login',
                ),
                const SizedBox(height: 5),
                /*
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
                            builder: (context) => const RegisterPage(),
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
                */
                //const SizedBox(height: 20),
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
                          'Device ID: ${snapshot.data ?? "Tidak tersedia"}', //\nFCM : $fcmToken',
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
                    //fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                //const SizedBox(height: 20), // Optional bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}
