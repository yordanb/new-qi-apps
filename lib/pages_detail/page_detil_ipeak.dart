//kode ke-2
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart'; // Import file config.dart
import '../auth/auth_service.dart';

class PageDetiliPeak extends StatelessWidget {
  final String nrp; // Tambahkan deklarasi nrp
  const PageDetiliPeak({super.key, required this.nrp}); // Perbaiki konstruktor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Ipeak'),
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
      body: FutureBuilder<List<dynamic>>(
        future: _fetchDataUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        _getAvatarColor(snapshot.data![index]['no']),
                    foregroundColor: Colors.black,
                    child: Text(
                      snapshot.data![index]['no'].toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  title: Text('Judul : ${snapshot.data![index]['judul']}'),
                  subtitle: Text(
                    'Akses : ${snapshot.data![index]['akses']}', //\nCreated : ${snapshot.data![index]['TanggalLaporan']}',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk mengambil data pengguna dari API
  Future<List<dynamic>> _fetchDataUsers() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/ipeak/$nrp";

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
      //print(result);

      // Pastikan respons memiliki data yang sesuai
      if (data != null && data['response'] != null) {
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
    final String apiUrl = "http://$apiIP:$apiPort/api/ipeak/$nrp";

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
      if (data == null || data['update'] == null) {
        return "Maaf Anda belum mengakses iPeak";
      }

      return data['update'];
    } catch (error) {
      // Handle error, misalnya return "No Data" atau error lainnya
      return "No Data"; // Mengembalikan "No Data" jika terjadi error
    }
  }

  Color _getAvatarColor(int jmlSS) {
    if (jmlSS < 1) {
      return Colors.redAccent;
    } else {
      return Colors.lightGreen;
    }
  }
}

