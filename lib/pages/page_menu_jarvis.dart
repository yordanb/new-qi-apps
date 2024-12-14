//kode ke-2
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:new_qi_apps/pages_detail/page_detil_jarvis.dart';
import '../auth/db_service.dart';
import '../config/config.dart'; // Import file config.dart
import 'package:new_qi_apps/auth/auth_service.dart';

class PageJarvis extends StatefulWidget {
  const PageJarvis({super.key});

  @override
  _PageJarvisState createState() => _PageJarvisState();
}

class _PageJarvisState extends State<PageJarvis> {
  String _selectedMenu2 = "staff";
  String _selectedMenu3 = "plt2";
  String dataCopiedToWA = ""; // Variabel untuk data yang akan disalin
  List<dynamic> responseData = [];
  String formattedString = "";

  Map<String, List<String>> menu2Items = {
    "staff": ["plt2", "pch", "sse", "big wheel", "tere", "lce", "psc"],
    "mech": ["pch", "mobile", "big wheel", "lighting", "pumping"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data JARVIS'),
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
              if (dataCopiedToWA.isNotEmpty) {
                await Clipboard.setData(ClipboardData(text: dataCopiedToWA));
                _showSnackBar(context, 'Data telah disalin ke clipboard');
              } else {
                _showSnackBar(context, 'Tidak ada data yang disalin');
              }
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
                    _selectedMenu3 =
                        menu2Items[_selectedMenu2]![0]; // Reset menu3
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
              future: _fetchDataUsers(),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageDetilJarvis(
                                    nrp: snapshot.data![index]['nrp'],
                                    crew: snapshot.data![index]['crew']),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                _getAvatarColor(snapshot.data![index]['doc']),
                            foregroundColor: Colors.black,
                            child: Text(
                              //snapshot.data![index]['doc'],
                              snapshot.data![index]['doc'].toString(),
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                            '${snapshot.data![index]['no']}. ${snapshot.data![index]['nama']}'),
                        subtitle: _selectedMenu3 == "plt2"
                            ? Text(
                                '(${snapshot.data![index]['nrp']})\n ${snapshot.data![index]['crew']}',
                              )
                            : Text(
                                '(${snapshot.data![index]['nrp']})',
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
        return "http://$apiIP:$apiPort/api/jarvis-allstaff-plt2";
      case 'zero':
        return "http://$apiIP:$apiPort/api/jarvis-mech-zero";
      default:
        return "http://$apiIP:$apiPort/api/jarvis-$_selectedMenu2/$_selectedMenu3";
    }
  }

  Future<List<dynamic>> _fetchDataUsers() async {
    String apiUrl = _buildApiUrl();
    var result = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );

    if (result.statusCode == 200) {
      var obj = json.decode(result.body);
      //print(obj['response']);
      dataCopiedToWA = obj['wa'] ?? ""; // Data yang akan disalin
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
        'Authorization': 'Bearer $userToken',
      },
    );

    if (result.statusCode == 200) {
      return json.decode(result.body)['update'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Color _getAvatarColor(int jmlDoc) {
    return jmlDoc < 1 ? Colors.redAccent : Colors.lightGreen;
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
