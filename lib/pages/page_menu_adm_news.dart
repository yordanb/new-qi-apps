// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:new_qi_apps/auth/auth_service.dart';
import '../config/config.dart'; // Import file config.dart
//import '../auth/db_service.dart'; // Import DBService to access shared preferences

class PageNews extends StatefulWidget {
  const PageNews({super.key});

  @override
  _PageNewsState createState() => _PageNewsState();
}

class _PageNewsState extends State<PageNews> {
  String dataCopiedToWA = "";
  List<dynamic> responseData = [];
  String formattedString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SS Class AB'),
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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fecthDataUsers(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Data tidak ditemukan'));
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: InkWell(
                          onTap: () {
                            /*
                            // Navigasi ke halaman detail dan kirim data NRP
                            DBService.set(
                                "nama", snapshot.data![index]['nama']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageDetilSS(
                                  nrp: snapshot.data![index]['nrp'],
                                ),
                              ),
                            );*/
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                _getAvatarColor(snapshot.data![index]['JmlSS']),
                            foregroundColor: Colors.black,
                            child: Text(
                              ssStatus,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        title: Text('${snapshot.data![index]['no']}. '
                            '${snapshot.data![index]['nama']}'),
                        subtitle: Text(
                          '(${snapshot.data![index]['nrp']})\n ${snapshot.data![index]['crew']}',
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _buildApiUrl() {
    return "http://$apiIP:$apiPort/api/ss-ab-plt2";
  }

  String crew = "";
  String ssStatus = "";
  Future<List<dynamic>> _fecthDataUsers() async {
    //_fecthDataUsersWA();
    // Ambil token yang disimpan

    String apiUrl = _buildApiUrl();
    //print(apiUrl);
    var result = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken', // Menyertakan token ke header
      },
    );
    //print("ok request Get kembali");

    if (result.statusCode == 200) {
      var obj = json.decode(result.body);
      //crew = obj["crew"];
      //print(obj['response']);
      //dataCopiedToWA = obj['wa'];
      //print(dataCopiedToWA);

      return obj['response'];
    } else {
      // Jika terjadi kesalahan pada permintaan HTTP, lemparkan Exception
      throw Exception('Failed to load data');
    }
  }

  Future<String> _fetchLastUpdateData() async {
    String apiUrl = _buildApiUrl();
    var result = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken', // Menyertakan token ke header
      },
    );

    if (result.statusCode == 200) {
      return json.decode(result.body)['update'];
    } else {
      // Jika terjadi kesalahan pada permintaan HTTP, lemparkan Exception
      throw Exception('Failed to load data');
    }
  }

  Color _getAvatarColor(int jmlSS) {
    if (jmlSS < 1) {
      ssStatus = "?";
      return Colors.redAccent;
    } else {
      ssStatus = "OK";
      return Colors.lightGreen;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
