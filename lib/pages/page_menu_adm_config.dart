/*
//kode ke-2
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
  Future<void> _updateData(
      int index, String newName, String newNrp, String newCrew) async {
    String apiUrl = "http://209.182.237.240:1880/edit";

    var body = jsonEncode(
        {"index": index, "nama": newName, "nrp": newNrp, "crew": newCrew});

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
  void _editItem(
      int index, String currentName, String currentNrp, String currentCrew) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController nrpController =
        TextEditingController(text: currentNrp);
    TextEditingController crewController =
        TextEditingController(text: currentCrew);

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
                controller: crewController,
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
                await _updateData(
                    index,
                    nameController.text,
                    nrpController.text,
                    crewController.text); // Kirim data ke server
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
                subtitle: Text('(${item['nrp']})\n${item['crew']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editItem(index, item['nama'], item['nrp'],
                            item['crew']); // Panggil fungsi edit
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
*/

//kode ke-3
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
  List<dynamic> _data = []; // Data yang diambil dari API
  List<dynamic> _filteredData = []; // Data yang difilter berdasarkan pencarian
  TextEditingController searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchData(); // Mengambil data ketika halaman dimuat
  }

  String _buildApiUrl() {
    return "http://$apiIP:$apiPort/api/mp";
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchData() async {
    String apiUrl = _buildApiUrl();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken', // Menyertakan token ke header
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _data = data['response'];
        _filteredData = _data;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Fungsi untuk mengirim data update ke server
  Future<void> _updateData(
      int index, String newName, String newNrp, String newCrew) async {
    String apiUrl = "http://209.182.237.240:1880/edit";

    var body = jsonEncode(
        {"index": index, "nama": newName, "nrp": newNrp, "crew": newCrew});

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
      fetchData(); // Refresh data setelah update
    } else {
      throw Exception('Failed to update data');
    }
  }

  // Fungsi untuk menampilkan dialog pop-up edit
  void _editItem(
      int index, String currentName, String currentNrp, String currentCrew) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController nrpController =
        TextEditingController(text: currentNrp);
    TextEditingController crewController =
        TextEditingController(text: currentCrew);

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
                controller: crewController,
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
                await _updateData(
                    index,
                    nameController.text,
                    nrpController.text,
                    crewController.text); // Kirim data ke server
                Navigator.of(context).pop(); // Tutup dialog setelah update
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk memfilter data berdasarkan NRP
  void _filterData(String query) {
    setState(() {
      _filteredData = _data
          .where((item) => item['nrp']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Cari berdasarkan NRP',
                ),
                onChanged: (query) => _filterData(query),
              )
            : const Text('Data Man Power'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  searchController.clear();
                  _filteredData = _data;
                }
              });
            },
          ),
        ],
      ),
      body: _filteredData.isEmpty
          ? const Center(child: Text('No Data Available'))
          : ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                var item = _filteredData[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(item['no'].toString())),
                  title: Text(item['nama']),
                  subtitle: Text('(${item['nrp']})\n${item['crew']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editItem(index, item['nama'], item['nrp'],
                              item['crew']); // Panggil fungsi edit
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
            ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PageConfig(),
  ));
}
