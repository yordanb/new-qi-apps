//kode ke-1
/*
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
*/

//kode ke-2
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:new_qi_apps/auth/auth_service.dart';
//import '../config/config.dart'; // Import file config.dart

class PageNews extends StatefulWidget {
  const PageNews({super.key});

  @override
  _PageNewsState createState() => _PageNewsState();
}

class _PageNewsState extends State<PageNews> {
  List<dynamic> responseData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Data'),
        centerTitle: true,
        /*
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
                return Text('Last Update: ${snapshot.data ?? 'No Data'}');
              }
            },
          ),
        ),
        */
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchDataFromApi(),
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
                      var item = snapshot.data![index];
                      /*
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          child: Text(
                            item['no'].toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        ),
                        title: Text('${item['nama']} (${item['nrp']})'),
                        subtitle:
                            Text('Last Seen: ${_formatSeenDate(item['seen'])}'),
                      );
                      */
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: _getBackgroundColor(item['seen']),
                          foregroundColor: Colors.white,
                          child: Text(
                            item['no'].toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        ),
                        title: Text('${item['nama']} (${item['nrp']})'),
                        subtitle:
                            Text('Last Seen: ${_formatSeenDate(item['seen'])}'),
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
    return "http://209.182.237.240:5005/api/log";
  }

  Future<List<dynamic>> _fetchDataFromApi() async {
    String apiUrl = _buildApiUrl();

    var result = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken', // Menyertakan token ke header
      },
    );

    if (result.statusCode == 200) {
      var obj = json.decode(result.body);
      return obj['response'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> _fetchLastUpdateData() async {
    String apiUrl = _buildApiUrl();

    var result = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (result.statusCode == 200) {
      var obj = json.decode(result.body);
      return obj['response'].isNotEmpty
          ? obj['response'][0]['seen']
          : 'No Updates';
    } else {
      throw Exception('Failed to load data');
    }
  }

/*
  String _formatSeenDate(String seen) {
    //print(seen);
    try {
      DateTime dateTime = DateTime.parse(seen).toLocal();
      return '${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    } catch (e) {
      return 'Invalid Date';
    }
  }
  */
  String _formatSeenDate(String seen) {
    try {
      DateTime dateTime = DateTime.parse(seen)
          .toUtc()
          .add(const Duration(hours: 8)); // Konversi ke WITA (UTC+8)
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      String month = months[dateTime.month - 1];
      String day = dateTime.day.toString().padLeft(2, '0');
      String hour = dateTime.hour.toString().padLeft(2, '0');
      String minute = dateTime.minute.toString().padLeft(2, '0');
      return '$day $month ${dateTime.year} $hour:$minute WITA';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  // Fungsi untuk menentukan warna background
  Color _getBackgroundColor(String seen) {
    try {
      DateTime seenDate = DateTime.parse(seen).toLocal();
      int todayDate = DateTime.now().day; // Ambil angka tanggal hari ini
      print('todaydate : $todayDate');
      int seenDateNumber = seenDate.day; // Ambil angka tanggal 'seen'
      print('seendate : $seenDateNumber');

      int difference = seenDateNumber - todayDate;
      print('hasilnya : $difference');

      if (difference == 0) {
        return Colors.green; // Jika 0 hingga -1
      } else if (difference >= -2 && difference < 0) {
        return Colors.deepOrange; // Jika -2 hingga -3
      } else {
        return Colors.grey; // Jika -3 ke bawah
      }
    } catch (e) {
      return Colors.red; // Jika terjadi kesalahan parsing
    }
  }
}
