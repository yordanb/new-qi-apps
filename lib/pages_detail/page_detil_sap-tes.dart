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
  String hariHadir = "0";
  String kta = "0";
  String ktaAcvh = "0";
  String tta = "0";
  String ttaAcvh = "0";
  String ta = "0";
  String ka = "0";
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
        print(data);
        setState(() {
          // Update state dengan data dari API
          nama = data['nama'] ?? 'Unknown';
          hariHadir = data['response'][0]['hari_hadir'] ?? 0;
          kta = data['response'][0]['kta_comp'] ?? 0;
          tta = data['response'][0]['tta_comp'] ?? 0;

          ktaAcvh = data['response'][0]['kta_acvh'] ?? 0.0;
          ttaAcvh = data['response'][0]['tta_acvh'] ?? 0.0;
          ta = data['response'][0]['ta'] ?? 0;
          ka = data['response'][0]['ka'] ?? 0;
          sapAcvh = double.tryParse(data['response'][0]['acvh_sap']) ?? 0.0;
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
                  'Acvh KTA : $ktaAcvh %',
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
                  'Acvh TTA : $ttaAcvh %',
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
