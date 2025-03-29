//kode ke-3
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth_service.dart';
import '../config/config.dart'; // Import file config.dart
import '../auth/db_service.dart';

class PageDetiliPeak extends StatelessWidget {
  final String nrp;

  const PageDetiliPeak({super.key, required this.nrp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: _fetchUserName(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return const Text('Unknown');
            } else {
              return Text(snapshot.data!);
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
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    child: Text(
                      snapshot.data![index]['no'].toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  title: Text(snapshot.data![index]['judul']),
                  subtitle: Text(
                    'Akses : ${snapshot.data![index]['akses']}',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchDataUsers() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/ipeak/$nrp";
    try {
      var result = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );
      var data = json.decode(result.body);
      if (data != null && data['response'] != null) {
        //nama = data['nama'];
        return data['response'];
      } else {
        return [];
      }
    } catch (error) {
      print("Error fetching data: $error");
      return [];
    }
  }

  Future<String> _fetchLastUpdateData() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/ipeak/$nrp";
    try {
      var result = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );
      var data = json.decode(result.body);
      if (data == null || data['update'] == null) {
        return "Maaf Anda belum akses iPeak";
      }
      return data['update'];
    } catch (error) {
      return "No Data";
    }
  }

  // Fungsi untuk mendapatkan nama pengguna dari DBService
  Future<String?> _fetchUserName() async {
    return DBService.get("nama"); // Mengambil nama dari SharedPreferences
  }
}
