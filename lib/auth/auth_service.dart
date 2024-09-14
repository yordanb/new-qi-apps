import 'dart:convert';
import '../config/config.dart';
import 'db_service.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:android_id/android_id.dart'; // Library untuk mendapatkan AndroidID

String? get userToken => DBService.get("token");
bool isAdmin = false;
bool isSpv = false;
bool isStaff = false;

class AuthService {
  // Mendapatkan AndroidID
  Future<String?> _getAndroidId() async {
    const androidIdPlugin = AndroidId();
    return await androidIdPlugin.getId();
  }

  // Mengecek apakah AndroidID sudah terdaftar
  Future<bool> checkAndroidID(String androidID) async {
    try {
      final response = await http.post(
        Uri.parse('http://$apiIP:$apiPort/auth/id-cek'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'androidID': androidID,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        if (responseData['status'] == "already_registered") {
          return true;
        }
        // Mengembalikan true jika sudah terdaftar
      }
      return false;
    } catch (err) {
      throw Exception("Error checking AndroidID: $err");
    }
  }

  // Fungsi login menggunakan NRP, password, dan AndroidID
  loginWithNRP({
    required String nrp,
    required String password,
  }) async {
    try {
      String? androidID = await _getAndroidId(); // Dapatkan AndroidID

      bool isRegistered =
          await checkAndroidID(androidID!); // Cek apakah AndroidID terdaftar
      if (!isRegistered) {
        // Jika AndroidID belum terdaftar, arahkan ke halaman registrasi
        // Navigator.of(context).pushReplacementNamed('/register'); // Sesuaikan dengan rute halaman registrasi
        throw Exception(
            "AndroidID not registered. Redirecting to registration.");
      }
      //print(isRegistered);

      var data = {
        'nrp': nrp,
        'password': password,
        //'androidID': androidID,
      };

      final response = await http.post(
        Uri.parse('http://$apiIP:$apiPort/auth/login'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print(json.decode(response.body));
        final Map<String, dynamic> responseData = json.decode(response.body);

        final String token = responseData['token'];
        print("ini token juga : ");
        print(token);

        // Simpan token ke dalam penyimpanan lokal
        DBService.set("token", token);
        DBService.set("expired_at",
            DateTime.now().add(const Duration(hours: 6)).toString());

        // Ambil role pengguna
        /*
        String role = await getRole(token);
        isAdmin = role == "Admin";
        isSpv = role == "Spv";
        isStaff = role == "Staff";
        */
      } else {
        throw Exception("Login failed");
      }
    } catch (err) {
      throw Exception("Login error: $err");
    }
  }

  // Fungsi untuk mendapatkan role pengguna berdasarkan token
  Future<String> getRole(String token) async {
    var response = await http.get(
      Uri.parse("http://$apiIP:$apiPort/api/role"),
      headers: {
        "authorization": "Bearer $token",
      },
    );
    var data = jsonDecode(response.body);
    return data["role"];
  }

  // Fungsi untuk memeriksa apakah token masih valid
  bool hasValidToken() {
    if (DBService.get("token") == null) return false;
    var expiredAtString = DBService.get("expired_at");
    DateTime expiredAt = DateTime.parse(expiredAtString.toString());
    DateTime now = DateTime.now();
    if (expiredAt.isBefore(now)) {
      return false;
    }
    return true;
  }
}
