//kode ke-2
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:convert';
import '../config/config.dart';

class PageTool extends StatefulWidget {
  const PageTool({super.key});

  @override
  State<PageTool> createState() => _PageToolState();
}

class _PageToolState extends State<PageTool> {
  File? _selectedFile;
  final TextEditingController _fileNameController = TextEditingController();
  String?
      _selectedRadio; // Variabel untuk menyimpan nama file dari radio button
  String _selectedDB = "SS"; // Default pilihan database untuk dropdown
  bool _isUploading = false; // Untuk menampilkan animasi loading

  // Nama file dari radio button
  final List<String> fileNames = [
    'ss-closed.xlsx',
    'ss-open.xlsx',
    'sap.xlsx',
    'esic.xlsx',
    'ipeak.xlsx',
  ];

  // Method untuk memilih file dari storage
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Method untuk upload file dengan POST
  Future<void> _uploadFile() async {
    if (_selectedFile == null || _selectedRadio == null) {
      Fluttertoast.showToast(msg: 'Please select a file and a name');
      return;
    }

    setState(() {
      _isUploading = true; // Mulai animasi loading
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://$apiIP:8888/'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'filetoupload', // Sesuaikan dengan nama field di server (disini: 'filetoupload')
        _selectedFile!.path,
        filename: _selectedRadio!, // Menggunakan nama file dari radio button
      ));

      // Mengirim permintaan
      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'File uploaded successfully');
      } else {
        Fluttertoast.showToast(msg: 'Failed to upload file');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() {
        _isUploading = false; // Selesai animasi loading
      });
    }
  }

  // Method untuk mengirim request POST ke DB Tool
  Future<void> _sendDbRequest(String action) async {
    try {
      final response = await http.post(
        Uri.parse('http://$apiIP:1880/db-tool'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'db': _selectedDB.toLowerCase(), 'action': action}),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Action $action on $_selectedDB database successful');
      } else {
        Fluttertoast.showToast(
            msg: 'Failed to execute $action on $_selectedDB database');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Upload File"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _pickFile,
                      child: const Text('Select File'),
                    ),
                    if (_selectedFile != null) ...[
                      const SizedBox(height: 20),
                      const Text("Choose a name for the file:"),
                      Column(
                        children: fileNames.map((fileName) {
                          return RadioListTile(
                            title: Text(fileName),
                            value: fileName,
                            groupValue: _selectedRadio,
                            onChanged: (value) {
                              setState(() {
                                _selectedRadio = value.toString();
                              });
                            },
                          );
                        }).toList(),
                      ),
                      if (_isUploading) ...[
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
                      ] else ...[
                        ElevatedButton(
                          onPressed: _uploadFile,
                          child: const Text('Upload File'),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            // Dropdown untuk memilih DB
            DropdownButton<String>(
              value: _selectedDB,
              items: ['SS', 'SAP', 'ESIC', 'IPEAK'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedDB = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _sendDbRequest('clean'),
                  child: const Text('Empty DB'),
                ),
                ElevatedButton(
                  onPressed: () => _sendDbRequest('update'),
                  child: const Text('Update DB'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
