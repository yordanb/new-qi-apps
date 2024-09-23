/*
//kode ke-2
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth_service.dart';
import '../config/config.dart'; // Import file config.dart
import '../auth/db_service.dart';

class PageDetilSAP extends StatelessWidget {
  String nrp;
  String nama = "abdul";
  int hariHadir = 9;
  int kta = 9;
  double ktaAcvh = 9;
  int tta = 9;
  double ttaAcvh = 9;
  int ta = 9;
  int ka = 9;
  double sapAcvh = 99.9;

  PageDetilSAP({super.key, required this.nrp}); // Perbaiki konstruktor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Ubah title untuk menggunakan nama dari DBService
        title: FutureBuilder<String?>(
          future:
              _fetchUserName(), // Fungsi untuk mengambil nama dari DBService
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                  'Loading...'); // Tampilkan loading saat menunggu
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return const Text('Unknown'); // Jika gagal atau nama kosong
            } else {
              return Text(
                  snapshot.data!); // Tampilkan nama yang diambil dari DBService
            }
          },
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: FutureBuilder<String>(
            future: _fetchLastUpdateData(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return Text(snapshot.data ?? 'No Data');
              }
            },
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Mulai dari atas
          children: [
            const SizedBox(
                height: 10), // Menambahkan spacer untuk memberi ruang ke atas
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$sapAcvh',
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
            // Teks "Nama"
            Text(
              'Nama: $nama',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),

            // Kehadiran
            Text(
              'Kehadiran: $hariHadir hari',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            //Elemen lainnya setelah lingkaran
            // Baris KTA dan Acvh
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'KTA: $kta',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 30),
                Text(
                  'Acvh KTA: $ktaAcvh %',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Baris TTA dan Acvh
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TTA: $tta',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 30),
                Text(
                  'Acvh TTA: $ttaAcvh %',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Baris TA
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TA: $ta',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Baris KA
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'KA: $ka',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 250),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mengambil data pengguna dari API
  Future<List<dynamic>> _fetchDataUsers() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/sap/$nrp";
    print(apiUrl);
    try {
      var result = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Menyertakan token ke header
        },
      );

      // Parsing hasil body
      var data = json.decode(result.body);

      // Pastikan respons memiliki data yang sesuai
      if (data != null && data['response'] != null) {
        // Update data dari response API
        nama = data['nama'] ?? '';
        hariHadir = data['hari_hadir'] ?? 0;
        ktaAcvh = data['kta_acvh'] ?? '';
        ttaAcvh = data['tta_acvh'] ?? '';
        ta = data['ta'] ?? 0;
        ka = data['ka'] ?? 0;
        sapAcvh = data['acvh_sap'] != null
            ? double.tryParse(data['acvh_sap'].toString()) ?? 0.0
            : 0.0;

        return data['response'];
      } else {
        // Kembalikan array kosong jika tidak ada data 'response'
        return [];
      }
    } catch (error) {
      // Tangani error dengan log atau melakukan tindakan lain
      print("Error fetching data: $error");
      // Kembalikan array kosong jika terjadi error
      return [];
    }
  }

  // Fungsi untuk mengambil update terakhir dari API
  Future<String> _fetchLastUpdateData() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/sap/$nrp";
    //print(apiUrl);
    try {
      var result = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Menyertakan token ke header
        },
      );

      // Parsing hasil body
      var data = json.decode(result.body);

      // Cek apakah data atau field 'update' bernilai null
      //print(data["nama"]);
      if (data == null || data['update'] == null) {
        return "No Data";
      }

      return data['update'];
    } catch (error) {
      // Handle error, misalnya return "No Data" atau error lainnya
      return "No Data"; // Mengembalikan "No Data" jika terjadi error
    }
  }

  // Fungsi untuk mendapatkan nama pengguna dari DBService
  Future<String?> _fetchUserName() async {
    return DBService.get("nama"); // Mengambil nama dari SharedPreferences
  }

  // Fungsi untuk menentukan warna avatar berdasarkan jumlah SS
  Color _getAvatarColor(int jmlSS) {
    if (jmlSS < 1) {
      return Colors.redAccent;
    } else if (jmlSS < 5) {
      return Colors.yellow;
    } else if (jmlSS < 6) {
      return Colors.lightGreen;
    } else {
      return Colors.lightBlue;
    }
  }
}
*/
//kode ke-3
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth_service.dart';
import '../config/config.dart'; // Import file config.dart

class PageDetilSAP extends StatefulWidget {
  final String nrp; // Tetap final karena ini diterima dari luar
  final String crew;

  const PageDetilSAP({super.key, required this.nrp, required this.crew});

  @override
  _PageDetilSAPState createState() => _PageDetilSAPState();
}

class _PageDetilSAPState extends State<PageDetilSAP> {
  String nama = "Loading...";
  int hariHadir = 0;
  int kta = 0;
  double ktaAcvh = 0.0;
  int tta = 0;
  double ttaAcvh = 0.0;
  int ta = 0;
  int ka = 0;
  double sapAcvh = 0.0;
  String lastUpdate = "Loading...";
  String crew = "Loading...";

  @override
  void initState() {
    super.initState();
    crew = widget.crew;
    _fetchDataUsers(); // Ambil data ketika widget diinisialisasi
  }

  // Fungsi untuk mengambil data pengguna dari API
  Future<void> _fetchDataUsers() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/sap/${widget.nrp}";
    print(apiUrl);
    try {
      var result = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Menyertakan token ke header
        },
      );

      // Parsing hasil body
      var data = json.decode(result.body);

      // Pastikan respons memiliki data yang sesuai
      if (data != null && data['response'] != null) {
        setState(() {
          // Update state dengan data dari API
          nama = data['nama'] ?? 'Unknown';
          hariHadir = data['response'][0]['hari_hadir'] ?? 0;
          ktaAcvh =
              double.tryParse(data['response'][0]['kta_acvh'].toString()) ??
                  0.0;
          ttaAcvh =
              double.tryParse(data['response'][0]['tta_acvh'].toString()) ??
                  0.0;
          ta = data['response'][0]['ta'] ?? 0;
          ka = data['response'][0]['ka'] ?? 0;
          sapAcvh = data['response'][0]['acvh_sap'] != null
              ? double.tryParse(data['response'][0]['acvh_sap'].toString()) ??
                  0.0
              : 0.0;
          lastUpdate = data['update'] ?? 'No Data';
        });
      } else {
        // Jika respons tidak ada data, set default value
        setState(() {
          nama = 'No Data';
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
      setState(() {
        nama = 'Error fetching data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SAP Achievement"), // Menampilkan nama dari data
        centerTitle: true,
        /*
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Text(lastUpdate),
        ),*/
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: _getAvatarColor(sapAcvh.toStringAsFixed(1)),
                //color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  sapAcvh.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Text(
              '( $crew )',
              style: const TextStyle(fontSize: 20),
            ),
            /*
            Text(
              nama,
              style: const TextStyle(
                  fontSize: 25,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),*/
            const SizedBox(height: 50),
            Text(
              'Kehadiran : $hariHadir hari',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'KTA : $kta',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 30),
                Text(
                  'Acvh KTA : $ktaAcvh%',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TTA : $tta',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 30),
                Text(
                  'Acvh TTA : $ttaAcvh%',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TA : $ta',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'KA : $ka',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 120),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Last update : \n$lastUpdate',
                  style: const TextStyle(
                    fontSize: 20,
                    //color: Colors.blue,
                    //fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(dynamic sap) {
    if (sap == null) {
      return Colors.red;
    } else if (sap is String) {
      // Coba untuk mengonversi nilai string menjadi double
      final double? sapDouble = double.tryParse(sap);
      if (sapDouble == null) {
        // Jika gagal mengonversi, kembalikan warna merah
        return Colors.red;
      }
      sap = sapDouble; // Gunakan nilai double yang sudah diubah
    }
    // Sekarang sap pasti bertipe double, lanjutkan dengan logika seperti sebelumnya
    if (sap < 70) {
      return Colors.redAccent;
    } else if (sap < 150) {
      return Colors.green;
    }
    return Colors.red;
  }
}
