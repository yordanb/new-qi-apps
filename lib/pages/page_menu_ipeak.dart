//kode ke-2
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import '../pages_detail/page_detil_ipeak.dart'; // Import halaman detail
import '../config/config.dart';
import 'package:new_qi_apps/auth/auth_service.dart';

class PageIpeak extends StatefulWidget {
  const PageIpeak({super.key});

  @override
  _PageIpeakState createState() => _PageIpeakState();
}

class _PageIpeakState extends State<PageIpeak> {
  String _selectedMenu2 = "staff";
  String _selectedMenu3 = "plt2";
  String dataCopiedToWA =
      ""; // Ini akan menyimpan data untuk disalin ke clipboard
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
        title: const Text('Data IPEAK'),
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
              // Pastikan `dataCopiedToWA` tidak kosong sebelum menyalin ke clipboard
              if (dataCopiedToWA.isNotEmpty) {
                await Clipboard.setData(ClipboardData(text: dataCopiedToWA));
                _showSnackBar(context, 'Data telah disalin');
              } else {
                _showSnackBar(context, 'Tidak ada data untuk disalin');
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
                                builder: (context) => PageDetiliPeak(
                                  nrp: snapshot.data![index]['nrp'],
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                _getAvatarColor(snapshot.data![index]['akses']),
                            foregroundColor: Colors.black,
                            child: Text(
                              snapshot.data![index]['akses'].toString(),
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                            '${snapshot.data![index]['no']}. ${snapshot.data![index]['nama']}'),
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
        return "http://$apiIP:$apiPort/api/ipeak-allstaff-plt2";
      case 'zero':
        return "http://$apiIP:$apiPort/api/ipeak-mech-zero";
      default:
        return "http://$apiIP:$apiPort/api/ipeak-$_selectedMenu2/$_selectedMenu3";
    }
  }

  Future<List<dynamic>> _fecthDataUsers() async {
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
      // Isi data untuk disalin ke WhatsApp
      dataCopiedToWA = obj['wa'] ?? '';
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

  Color _getAvatarColor(int frekAkses) {
    return frekAkses < 1 ? Colors.redAccent : Colors.lightGreen;
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
