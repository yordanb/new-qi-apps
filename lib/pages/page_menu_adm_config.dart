/*
// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:new_qi_apps/auth/auth_service.dart';
import '../config/config.dart'; // Import file config.dart
//import '../auth/db_service.dart'; // Import DBService to access shared preferences

class PageConfig extends StatefulWidget {
  const PageConfig({super.key});

  @override
  _PageConfigState createState() => _PageConfigState();
}

class _PageConfigState extends State<PageConfig> {
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
                          /*
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
                          ),*/
                        ),
                        title: Text('${snapshot.data![index]['id']}. '
                            '${snapshot.data![index]['Nama']}'),
                        subtitle: Text(
                          '(${snapshot.data![index]['NRP']})\n ${snapshot.data![index]['Crew']}',
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
    return "http://$apiIP:$apiPort/api/mp";
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
      print(obj['data']);

      return obj;
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

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
*/
import 'dart:convert'; // untuk jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import 'package:new_qi_apps/auth/auth_service.dart';

class PageConfig extends StatefulWidget {
  const PageConfig({super.key});

  @override
  _PageConfigState createState() => _PageConfigState();
}

class _PageConfigState extends State<PageConfig> {
  String _buildApiUrl() {
    return "http://$apiIP:$apiPort/api/mp";
  }

  // Fungsi untuk mengambil data dari API
  Future<List<dynamic>> fetchData() async {
    String apiUrl = _buildApiUrl();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken', // Menyertakan token ke header
      },
    );

    if (response.statusCode == 200) {
      // Jika server mengembalikan respon OK, kita decode data JSON-nya
      var data = jsonDecode(response.body);
      return data['response']; // Mengambil array response
    } else {
      // Jika terjadi kesalahan, lemparkan exception
      throw Exception('Failed to load data');
    }
  }

  // Fungsi untuk mengirim data update ke server
  Future<void> _updateData(int index, String newName, String newNrp) async {
    String apiUrl = "http://209.182.237.240:1880/edit";

    var body = jsonEncode({"index": index, "nama": newName, "nrp": newNrp});

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken', // Sertakan token
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print("Update successful");
      setState(() {
        // Perbarui state setelah sukses
      });
    } else {
      throw Exception('Failed to update data');
    }
  }

  // Fungsi untuk menampilkan dialog pop-up edit
  void _editItem(int index, String currentName, String currentNrp) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController nrpController =
        TextEditingController(text: currentNrp);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: nrpController,
                decoration: const InputDecoration(labelText: 'NRP'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Section'),
              ),
              TextField(
                controller: nrpController,
                decoration: const InputDecoration(labelText: 'Crew'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            ElevatedButton(
              child: const Text('Update'),
              onPressed: () async {
                await _updateData(index, nameController.text,
                    nrpController.text); // Kirim data ke server
                Navigator.of(context).pop(); // Tutup dialog setelah update
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Man Power'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(), // Mengambil data dari API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Tampilkan loading
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Tampilkan error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No Data Available')); // Jika data kosong
          }

          // Jika data berhasil diambil, tampilkan dalam ListView
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var item = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(child: Text(item['no'].toString())),
                title: Text(item['nama']),
                subtitle: Text('(${item['nrp']})'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editItem(index, item['nama'],
                            item['nrp']); // Panggil fungsi edit
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Fungsi hapus bisa ditambahkan di sini
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PageConfig(),
  ));
}
