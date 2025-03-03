//kode ke-2
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
  List<dynamic> _dataMP = [];
  List<dynamic> _dataUser = [];
  List<dynamic> _filteredData = [];

  TextEditingController searchController = TextEditingController();
  bool _isSearching = false;
  bool _isMPSelected = true; // Untuk toggle antara MP dan User data
  //bool isDefPass = false; // Variabel untuk menyimpan status

  @override
  void initState() {
    super.initState();
    fetchDataMP();
    //fetchDataUser();
  }

  String _buildApiUrlMP() => "http://$apiIP:$apiPort/api/mp";
  String _buildApiUrlUser() => "http://$apiIP:$apiPort/api/user";

  Future<void> fetchDataMP() async {
    String apiUrl = _buildApiUrlMP();
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
        _dataMP = data['response'];
        if (_isMPSelected) _filteredData = _dataMP;
      });
    } else {
      showError('Failed to load MP data');
    }
  }

  Future<void> fetchDataUser() async {
    String apiUrl = _buildApiUrlUser();
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
        _dataUser = data['response'];
        if (!_isMPSelected) _filteredData = _dataUser;
      });
    } else {
      showError('Failed to load User data');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleDataSource(bool isMP) {
    setState(() {
      _isMPSelected = isMP;
      _filteredData = isMP ? _dataMP : _dataUser;
    });
  }

  void _editItemMP(String currentName, String currentNrp, String currentCrew) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController nrpController =
        TextEditingController(text: currentNrp);
    TextEditingController crewController =
        TextEditingController(text: currentCrew);
    var nrpSaiki = currentNrp;

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
                await _updateDataMP(nrpSaiki, nameController.text,
                    nrpController.text, crewController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editItemUser(String currentName, String currentNrp, String currentLevel,
      String currentAndroidID) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController nrpController =
        TextEditingController(text: currentNrp);
    TextEditingController levelController =
        TextEditingController(text: currentLevel);
    TextEditingController androidIDController =
        TextEditingController(text: currentAndroidID);
    var nrpSaiki = currentNrp;
    String? selectedLevel;
    selectedLevel = levelController.text;

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
              DropdownButtonFormField<String>(
                value: selectedLevel,
                decoration: const InputDecoration(labelText: 'Level'),
                items: ['Staff', 'Admin']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value; // Perbarui nilai selectedLevel
                  });
                },
              ),
              TextField(
                controller: androidIDController,
                decoration: const InputDecoration(labelText: 'Android ID'),
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
                await _updateDataUser(
                    nrpSaiki,
                    nameController.text,
                    nrpController.text,
                    selectedLevel!,
                    androidIDController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDataMP(String nrp) async {
    String apiUrl = "http://$apiIP:$apiPort/api/mp/$nrp";

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      //print("Deletion successful");
      fetchDataMP();
    } else {
      throw Exception('Failed to delete data');
    }
  }

  void _confirmDeleteMP(String nrp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus NRP $nrp?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await _deleteDataMP(nrp);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDataUser(String nrp) async {
    String apiUrl = "http://$apiIP:$apiPort/api/user/$nrp";

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      //print("Deletion successful");
      fetchDataUser();
    } else {
      throw Exception('Failed to delete data');
    }
  }

  void _confirmDeleteUser(String nrp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus NRP $nrp?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await _deleteDataUser(nrp);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateDataMP(
      String currentNrp, String newName, String newNrp, String newCrew) async {
    String apiUrl = "http://$apiIP:$apiPort/api/mp/$currentNrp";

    var body = jsonEncode({"Nama": newName, "NRP": newNrp, "Crew": newCrew});

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      //print("Update successful");
      fetchDataMP();
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> _updateDataUser(String currentNrp, String newName, String newNrp,
      String newLevel, String newAndroidID) async {
    String apiUrl = "http://$apiIP:$apiPort/api/user/$currentNrp";

    var body = jsonEncode({
      "Nama": newName,
      "NRP": newNrp,
      "Role": newLevel,
      "android_id": newAndroidID
    });
    //print(body);

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
      body: body,
    );
    //print(response.body);

    if (response.statusCode == 200) {
      //print("Update successful");
      fetchDataUser();
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> _addDataMP(
      String newName, String newNrp, String newCrew, String newPosisi) async {
    String apiUrl = _buildApiUrlMP();

    var body = jsonEncode(
        {"Nama": newName, "NRP": newNrp, "Crew": newCrew, "Posisi": newPosisi});
    //print(body);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      //print("Addition successful");
      fetchDataMP();
    } else {
      throw Exception('Failed to add data');
    }
    return;
  }

  Future<void> _addDataUser(String newName, String newNrp, String newLevel,
      String newID, String isDefPass) async {
    String apiUrl = _buildApiUrlUser();

    var body = jsonEncode({
      "Nama": newName,
      "NRP": newNrp,
      "Role": newLevel,
      "android_id": newID,
      "is_default_password": isDefPass
    });
    //print(body);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      //print("Addition successful");
      fetchDataMP();
    } else {
      throw Exception('Failed to add data');
    }
  }

  void _filterData(String query) {
    setState(() {
      List<dynamic> data = _isMPSelected ? _dataMP : _dataUser;
      _filteredData = data
          .where((item) => item['nrp']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())||
        item['nama'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showAddManPowerDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController nrpController = TextEditingController();
    //TextEditingController crewController = TextEditingController();
    String? selectedPosisi;
    String? selectedCrew; // Variabel untuk menyimpan pilihan posisi

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Data ManPower'),
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
              DropdownButtonFormField<String>(
                value: selectedPosisi,
                decoration: const InputDecoration(labelText: 'Posisi'),
                items: ['Staff', 'Mekanik']
                    .map((posisi) => DropdownMenuItem(
                          value: posisi,
                          child: Text(posisi),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedPosisi = value;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedCrew,
                decoration: const InputDecoration(labelText: 'Crew'),
                items: [
                  'PCH',
                  'Big Wheel',
                  'Mobile',
                  'Pumping',
                  'Lighting',
                  'LCE',
                  'MTE'
                ]
                    .map((crew) => DropdownMenuItem(
                          value: crew,
                          child: Text(crew),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedCrew = value;
                },
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
                if (selectedPosisi != null) {
                  await _addDataMP(
                    nameController.text,
                    nrpController.text,
                    //crewController.text,
                    selectedCrew!,
                    selectedPosisi!,
                  );
                  Navigator.of(context).pop();
                } else {
                  // Menampilkan pesan jika posisi belum dipilih
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Pilih posisi terlebih dahulu!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddUserDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController nrpController = TextEditingController();
    TextEditingController idController = TextEditingController();
    String? isDefPass; // Variabel untuk menyimpan status
    String? selectedLevel;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Data User Apps'),
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
              DropdownButtonFormField<String>(
                value: selectedLevel,
                decoration: const InputDecoration(labelText: 'Level'),
                items: ['Staff', 'Admin']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value; // Perbarui nilai selectedLevel
                  });
                },
              ),
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'ID Android'),
              ),
              DropdownButtonFormField<String>(
                value: isDefPass,
                decoration: const InputDecoration(labelText: 'is Def Pass'),
                items: ['Yes', 'No']
                    .map((isDefPass) => DropdownMenuItem(
                          value: isDefPass,
                          child: Text(isDefPass),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    isDefPass = value; // Perbarui nilai selectedLevel
                  });
                },
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
                String newDefPass = "1";
                if (isDefPass == "Yes") {
                  newDefPass = '1';
                } else {
                  newDefPass = '0';
                }
                await _addDataUser(nameController.text, nrpController.text,
                    selectedLevel!, idController.text, newDefPass);
                Navigator.of(context).pop();
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
        title: _isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Cari berdasarkan NRP',
                ),
                onChanged: _filterData,
              )
            : const Text('MP Config'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_reaction_outlined),
            onPressed: _showAddUserDialog,
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showAddManPowerDialog,
          ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  searchController.clear();
                  _filteredData =
                      _isMPSelected ? _dataMP : _dataUser; // Reset data
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _toggleDataSource(true);
                  fetchDataMP();
                },
                style: ButtonStyle(
                    fixedSize: WidgetStateProperty.all<Size>(
                  const Size(120.0, 30.0), // Button width and height
                )),
                child: const Text('MP'),
              ),
              ElevatedButton(
                onPressed: () {
                  _toggleDataSource(false);
                  fetchDataUser();
                },
                style: ButtonStyle(
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(120.0, 30.0), // Button width and height
                  ),
                ),
                child: const Text('User App'),
              ),
            ],
          ),
          Expanded(
            child: _filteredData.isEmpty
                ? const Center(child: Text('No Data Available'))
                : ListView.builder(
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      var item = _filteredData[index];
                      return ListTile(
                        leading:
                            CircleAvatar(child: Text(item['no'].toString())),
                        title: Text(item['nama']),
                        subtitle: _isMPSelected
                            ? Text('(${item['nrp']})\n${item['crew']}')
                            : Text(
                                '(${item['nrp']}) - ${item['level']}\n${item['androidID']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                if (_isMPSelected) {
                                  _editItemMP(
                                      item['nama'], item['nrp'], item['crew']);
                                }
                                _editItemUser(item['nama'], item['nrp'],
                                    item['level'], item['androidID']);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (_isMPSelected) {
                                  _confirmDeleteMP(item['nrp']);
                                } else {
                                  _confirmDeleteUser(item['nrp']);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
