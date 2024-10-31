//kode ke-1

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:new_qi_apps/auth/auth_service.dart';
import '../auth/db_service.dart';
import '../pages_detail/page_detil_ss.dart'; // Import halaman detail
import '../config/config.dart'; // Import file config.dart
//import '../auth/db_service.dart'; // Import DBService to access shared preferences

class PageSS extends StatefulWidget {
  const PageSS({super.key});

  @override
  _PageSSState createState() => _PageSSState();
}

class _PageSSState extends State<PageSS> {
  //final String _selectedMenu1 = "ss";
  String _selectedMenu2 = "staff";
  String _selectedMenu3 = "plt2";
  String dataCopiedToWA = "";
  List<dynamic> responseData = [];
  String formattedString = "";

  //List<String> menu1Items = ["ss"];
  Map<String, List<String>> menu2Items = {
    "staff": ["plt2", "pch", "sse", "big wheel", "tere", "lce", "psc"],
    "mech": ["pch", "mobile", "big wheel", "lighting", "pumping", "zero", "<5"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Sugestion System'),
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
        actions: [
          IconButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: dataCopiedToWA));
              _showSnackBar(context, 'Data telah disalin');
            },
            icon: const Icon(Icons.content_copy),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
              DropdownButton<String>(
                value: _selectedMenu1,
                items: menu1Items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMenu1 = newValue!;
                  });
                },
              ),*/
              DropdownButton<String>(
                value: _selectedMenu2,
                items: menu2Items.keys.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMenu2 = newValue!;
                    // Reset selected menu 3 when menu 2 changes
                    _selectedMenu3 = menu2Items[_selectedMenu2]![0];
                  });
                },
              ),
              DropdownButton<String>(
                value: _selectedMenu3,
                items: menu2Items[_selectedMenu2]!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMenu3 = newValue!;
                  });
                },
              ),
            ],
          ),
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
                            // Navigasi ke halaman detail dan kirim data NRP
                            DBService.set(
                                "nama", snapshot.data![index]['nama']);
                            DBService.set(
                                "crew", snapshot.data![index]['crew']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageDetilSS(
                                  nrp: snapshot.data![index]['nrp'],
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                _getAvatarColor(snapshot.data![index]['JmlSS']),
                            foregroundColor: Colors.black,
                            child: Text(
                              snapshot.data![index]['JmlSS'].toString(),
                              style: const TextStyle(
                                fontSize: 25,
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
    switch (_selectedMenu3) {
      case 'plt2':
        return "http://$apiIP:$apiPort/api/ss-staff-plt2";
      case 'zero':
        return "http://$apiIP:$apiPort/api/ss-mech-zero";
      case '<5':
        return "http://$apiIP:$apiPort/api/ss-mech-5";
      default:
        return "http://$apiIP:$apiPort/api/ss-$_selectedMenu2/$_selectedMenu3";
    }
  }

  String crew = "";
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
      dataCopiedToWA = obj['wa'];
      //print(dataCopiedToWA);

      return obj['response'];
    } else {
      // Jika terjadi kesalahan pada permintaan HTTP, lemparkan Exception
      throw Exception('Failed to load data');
    }
  }
/*
  Future<String> _fecthDataUsersWA() async {
    String apiUrl = _buildApiUrl();
    var result = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken', // Menyertakan token ke header
      },
    );

    if (result.statusCode == 200) {
      Map<String, dynamic> obj = json.decode(result.body);
      dataCopiedToWA = obj['response2'] ?? "";
      return dataCopiedToWA;
    } else {
      // Jika terjadi kesalahan pada permintaan HTTP, lemparkan Exception
      throw Exception('Failed to load data');
    }
  }
  */

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
      return Colors.redAccent;
    } else if (jmlSS < 5) {
      return Colors.yellow;
    } else if (jmlSS < 6) {
      return Colors.lightGreen;
    } else {
      return Colors.lightBlue;
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
