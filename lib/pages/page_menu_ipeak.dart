import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
//import '../pages_detail/page_detil_ipeak.dart'; // Import halaman detail
import '../config/config.dart';

class PageIpeak extends StatefulWidget {
  const PageIpeak({super.key});

  @override
  _PageIpeakState createState() => _PageIpeakState();
}

class _PageIpeakState extends State<PageIpeak> {
  //final String _selectedMenu1 = "ss";
  String _selectedMenu2 = "staff";
  String _selectedMenu3 = "plt2";
  String dataCopiedToWA = "";
  List<dynamic> responseData = [];
  String formattedString = "";

  //List<String> menu1Items = ["ss"];
  Map<String, List<String>> menu2Items = {
    "staff": ["plt2", "pch", "sse", "big wheel", "tere", "lce", "psc"],
    "mech": ["pch", "mobile", "big wheel", "lighting", "pumping"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Data IPEAK'),
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
                          /*
                          onTap: () {
                            // Navigasi ke halaman detail dan kirim data NRP
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageDetilESIC(
                                  nrp: snapshot.data![index]['mp_nrp'],
                                ),
                              ),
                            );
                          },*/
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: _getAvatarColor(
                                snapshot.data![index]['frekAkses']),
                            foregroundColor: Colors.black,
                            child: Text(
                              snapshot.data![index]['frekAkses'].toString(),
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                            '${snapshot.data![index]['no']}. ${snapshot.data![index]['mp_nama']}'),
                        subtitle: Text(
                            '(${snapshot.data![index]['mp_nrp']})\n ${snapshot.data![index]['posisi']}'),
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
        return "http://$apiIP:$apiPort/api/ipeak-staff-rank";
      case 'zero':
        return "http://$apiIP:$apiPort/api/mech-zero";
      default:
        return "http://$apiIP:$apiPort/api/ipeak-$_selectedMenu2/$_selectedMenu3";
    }
  }

  Future<List<dynamic>> _fecthDataUsers() async {
    _fecthDataUsersWA();
    String apiUrl = _buildApiUrl();
    var result = await http.get(Uri.parse(apiUrl));

    if (result.statusCode == 200) {
      return json.decode(result.body)['response'];
    } else {
      // Jika terjadi kesalahan pada permintaan HTTP, lemparkan Exception
      throw Exception('Failed to load data');
    }
  }

  Future<String> _fecthDataUsersWA() async {
    String apiUrl = _buildApiUrl();
    var result = await http.get(Uri.parse(apiUrl));

    if (result.statusCode == 200) {
      dataCopiedToWA = json.decode(result.body)['response2'];
      return json.decode(result.body)['response2'];
    } else {
      // Jika terjadi kesalahan pada permintaan HTTP, lemparkan Exception
      throw Exception('Failed to load data');
    }
  }

  Future<String> _fetchLastUpdateData() async {
    String apiUrl = _buildApiUrl();
    var result = await http.get(Uri.parse(apiUrl));

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
    } else {
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
