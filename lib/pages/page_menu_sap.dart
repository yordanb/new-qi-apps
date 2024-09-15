import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import '../pages_detail/page_detil_sap.dart'; // Import halaman detail
import '../config/config.dart'; // Import file config.dart
import 'package:new_qi_apps/auth/auth_service.dart';

class PageMenuSAP extends StatefulWidget {
  const PageMenuSAP({super.key});

  @override
  _PageSAPState createState() => _PageSAPState();
}

class _PageSAPState extends State<PageMenuSAP> {
  //final String _selectedMenu1 = "sap";
  String _selectedMenu2 = "staff";
  String _selectedMenu3 = "pch";
  String dataCopiedToWA = "";
  List<dynamic> responseData = [];
  String formattedString = "";

  //List<String> menu1Items = ["sap"];
  Map<String, List<String>> menu2Items = {
    "staff": ["pch", "sse", "big wheel", "tere", "lce", "psc"],
    "mech": ["pch", "mobile", "big wheel", "lighting", "pumping"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Data SAP'),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageDetilSAP(
                                  nrp: snapshot.data![index]['mp_nrp'],
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: _getAvatarColor(
                                formatSAP(snapshot.data![index]['sap'])),
                            foregroundColor: Colors.black,
                            child: Text(
                              //snapshot.data![index]['sap'].toString(),
                              formatSAP(snapshot.data![index]['sap']),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          '${snapshot.data![index]['no']}. '
                          '${snapshot.data![index]['nama']}',
                        ),
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
        return "http://$apiIP:$apiPort/api/staff-rank";
      case 'zero':
        return "http://$apiIP:$apiPort/api/mech-zero";
      case '<5':
        return "http://$apiIP:$apiPort/api/mech-5";
      default:
        return "http://$apiIP:$apiPort/api/sap-$_selectedMenu2/$_selectedMenu3";
    }
  }

  String crew = "";
  Future<List<dynamic>> _fecthDataUsers() async {
    _fecthDataUsersWA();
    // Ambil token yang disimpan

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
      //crew = obj["crew"];
      return obj['response'];
    } else {
      // Jika terjadi kesalahan pada permintaan HTTP, lemparkan Exception
      throw Exception('Failed to load data');
    }
  }

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
      return Colors.lightGreen;
    }
    return Colors.red;
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String formatSAP(dynamic sapData) {
    if (sapData is String) {
      double? sapDouble = double.tryParse(sapData);
      if (sapDouble != null) {
        String sapString = sapDouble.toStringAsFixed(
            1); // Mengonversi ke string dengan dua angka di belakang koma
        if (sapString.endsWith('.00')) {
          return sapString.substring(
              0, sapString.length - 3); // Hapus ".00" jika ada
        }
        return sapString;
      }
    }
    return sapData
        .toString(); // Kembalikan nilai asli jika bukan string atau tidak dapat diubah menjadi double
  }
}
