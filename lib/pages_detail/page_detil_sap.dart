import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart'; // Import file config.dart

class PageDetilSAP extends StatelessWidget {
  final String nrp; // Tambahkan deklarasi nrp
  const PageDetilSAP({super.key, required this.nrp}); // Perbaiki konstruktor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail SAP'),
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
        future: _fecthDataUsers(),
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
                    radius: 45,
                    backgroundColor: _getAvatarColor(
                        formatSAP(snapshot.data![index]['AcvhSAP'])),
                    foregroundColor: Colors.black,
                    child: Text(
                      formatSAP(snapshot.data![index]['AcvhSAP'].toString()),
                      //snapshot.data![index]['AcvhSAP'].toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  title: Text(
                    snapshot.data![index]['mp_nama'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    '(${snapshot.data![index]['mp_nrp']})\n${snapshot.data![index]['mp_crew']}\nHari Hadir : ${snapshot.data![index]['sap_hadir']} hari\nKTA Completed : ${snapshot.data![index]['KTACompleted']}\nAcvh KTA : ${snapshot.data![index]['KTAAcvh']}\nTTA Completed : ${snapshot.data![index]['TTACompleted']}\nAcvh TTA : ${snapshot.data![index]['TTAAcvh']}\nTA : ${snapshot.data![index]['TA']}\nKA : ${snapshot.data![index]['KA']}\nAcvh SAP : ${snapshot.data![index]['AcvhSAP']} %\n',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> _fecthDataUsers() async {
    final String apiUrl =
        "http://$apiIP:$apiPort/api/sap/$nrp"; // Gunakan data NRP yang diterima
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['response'];
  }

  Future<String> _fetchLastUpdateData() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/sap/$nrp";
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['update'];
  }

  Color _getAvatarColor(dynamic sap) {
    if (sap == null) {
      return Colors.red;
    } else if (sap is String) {
      // Coba untuk mengonversi nilai string menjadi double
      final double? sapDouble = double.tryParse(sap);
      if (sapDouble == null) {
        // Jika gagal mengonversi, kembalikan warna merah
        return const Color.fromARGB(255, 114, 54, 244);
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
