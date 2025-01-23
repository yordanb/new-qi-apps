//kode ke-4
//kode ke-3
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth_service.dart';
import '../config/config.dart';

class PageDetilJarvis extends StatefulWidget {
  final String nrp;
  final String crew;

  const PageDetilJarvis({super.key, required this.nrp, required this.crew});
  //const PageDetilJarvis({super.key, required this.nrp});

  @override
  _PageDetilJarvisState createState() => _PageDetilJarvisState();
}

class _PageDetilJarvisState extends State<PageDetilJarvis> {
  String nama = "Loading...";
  int jarvisAchv = 0;
  String lastUpdate = "Loading...";
  String nrp = "Loading...";
  List<String> judulList = [];
  List<String> judulList2 = [];
  String dataCopiedToWA = "";
  String crew = "Loading...";
  bool hasAccessedJarvis = true;

  @override
  void initState() {
    super.initState();
    nrp = widget.nrp;
    crew = widget.crew;
    _fetchDataUsers();
  }

  Future<void> _fetchDataUsers() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/jarvis/${widget.nrp}";
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
        setState(() {
          nama = data['nama'] ?? 'Unknown';
          jarvisAchv = int.tryParse(data['response']['doc']) ?? 0;
          lastUpdate = data['update'] ?? 'No Data';
          judulList = data['response']['judul'].split('|');

          // Cek apakah data2 adalah "belum akses jarvis"
          if (data['response']['data2'] == "belum akses jarvis") {
            hasAccessedJarvis = false;
          } else {
            judulList2 = data['response']['data2'].split('|');
            hasAccessedJarvis = true;
          }

          dataCopiedToWA = data['response']['wa'];
          dataCopiedToWA += 'Last update : \n$lastUpdate';
        });
      } else {
        setState(() {
          nama = 'No Data';
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
      setState(() {
        nama = 'Error fetching data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jarvis Achv"),
        centerTitle: true,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getAvatarColor(jarvisAchv),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  jarvisAchv.toString(),
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '( $crew )',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const Text("Judul yang telah dibaca bulan lalu :",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: judulList.length,
                itemBuilder: (context, index) {
                  final judul = judulList[index].split('- revisi');
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      judul[0].trim(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Revisi: ${judul.length > 1 ? judul[1].trim() : "0"}',
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text("Judul yang telah dibaca bulan ini :",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: hasAccessedJarvis
                  ? ListView.builder(
                      itemCount: judulList2.length,
                      itemBuilder: (context, index) {
                        final judul2 = judulList2[index].split('- revisi');
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.lightGreen,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            judul2[0].trim(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            'Revisi: ${judul2.length > 1 ? judul2[1].trim() : "0"}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.grey),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "Maaf Anda belum mengakses jarvis",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 5),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Last update : \n$lastUpdate',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(dynamic jarvis) {
    if (jarvis == null) {
      return Colors.red;
    } else if (jarvis is String) {
      final int? jarvisInt = int.tryParse(jarvis);
      if (jarvisInt == null) {
        return Colors.red;
      }
      jarvis = jarvisInt;
    }
    if (jarvis < 1) {
      return Colors.redAccent;
    } else {
      return Colors.green;
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
