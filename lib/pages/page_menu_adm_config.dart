//kode ke-4
import 'dart:convert';
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
  List<dynamic> _data = [];
  List<dynamic> _filteredData = [];
  TextEditingController searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String _buildApiUrl() {
    return "http://$apiIP:$apiPort/api/mp";
  }

  Future<void> fetchData() async {
    String apiUrl = _buildApiUrl();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
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

  Future<void> _updateData(
      int index, String newName, String newNrp, String newCrew) async {
    String apiUrl = "http://209.182.237.240:1880/edit";

    var body = jsonEncode(
        {"index": index, "nama": newName, "nrp": newNrp, "crew": newCrew});

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print("Update successful");
      fetchData();
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> _addData(String newName, String newNrp, String newCrew) async {
    String apiUrl = "http://209.182.237.240:1880/add";

    var body = jsonEncode({"nama": newName, "nrp": newNrp, "crew": newCrew});

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print("Addition successful");
      fetchData();
    } else {
      throw Exception('Failed to add data');
    }
  }

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
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Update'),
              onPressed: () async {
                await _updateData(index, nameController.text,
                    nrpController.text, crewController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddPersonDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController nrpController = TextEditingController();
    TextEditingController crewController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Data Man Power'),
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
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async {
                await _addData(nameController.text, nrpController.text,
                    crewController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
            icon: const Icon(Icons.person_add),
            onPressed: _showAddPersonDialog,
          ),
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
                          _editItem(
                              index, item['nama'], item['nrp'], item['crew']);
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
