import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart'; // Import file config.dart

class PageDetilJarvis extends StatelessWidget {
  final String nrp; // Tambahkan deklarasi nrp
  const PageDetilJarvis({super.key, required this.nrp}); // Perbaiki konstruktor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JUDUL SS'),
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
                    radius: 30,
                    backgroundColor:
                        _getAvatarColor(snapshot.data![index]['no']),
                    foregroundColor: Colors.black,
                    child: Text(
                      snapshot.data![index]['no'].toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  title: Text(snapshot.data![index]['Judul']),
                  subtitle: Text(
                    'Status : ${snapshot.data![index]['KategoriSS']}\nCreated : ${snapshot.data![index]['TanggalLaporan']}',
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
        "http://$apiIP:$apiPort/api/jarvis/$nrp"; // Gunakan data NRP yang diterima
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['response'];
  }

  Future<String> _fetchLastUpdateData() async {
    final String apiUrl = "http:///$apiIP:$apiPort/api/jarvis/$nrp";
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['update'];
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
}
