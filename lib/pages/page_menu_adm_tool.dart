//kode ke-4
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart';

class PageTool extends StatefulWidget {
  const PageTool({super.key});

  @override
  State<PageTool> createState() => _PageToolState();
}

class _PageToolState extends State<PageTool> {
  File? _selectedFile;
  String? _selectedMenu;
  String _selectedDB = "SS";
  String _selectedMonth = "01";
  bool _isUploading = false;

  final List<String> fileNames = [
    'ss-closed.xlsx',
    'ss-open.xlsx',
    'ss-ab.xlsx',
    'sap.xlsx',
    'ipeak.xlsx',
    'esic.xlsx',
    'esic-mtd.xlsx',
  ];

  final List<String> monthNumbers = [
    for (int i = 1; i <= 12; i++) i.toString().padLeft(2, '0')
  ];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null || _selectedMenu == null) {
      Fluttertoast.showToast(msg: 'Please select a file and a name');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      String fileName = _selectedMenu!;
      if (_selectedMenu == 'esic-mtd.xlsx') {
        fileName = 'esic-mtd-$_selectedMonth.xlsx';
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://$apiIP:8888/'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'filetoupload',
        _selectedFile!.path,
        filename: fileName,
      ));

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
        _isUploading = false;
      });
    }
  }

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

  Future<void> _showConfirmationDialog(String action) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Dialog tidak bisa ditutup dengan klik di luar
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text('Do you want to $action the $_selectedDB database?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
                _sendDbRequest(action); // Jalankan aksi jika "Yes"
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Upload File"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
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
                      DropdownButton<String>(
                        value: _selectedMenu,
                        items: fileNames.map((String fileName) {
                          return DropdownMenuItem<String>(
                            value: fileName,
                            child: Text(fileName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMenu = value;
                          });
                        },
                      ),
                      if (_selectedMenu == 'esic-mtd.xlsx') ...[
                        const SizedBox(height: 10),
                        const Text("Select Month:"),
                        DropdownButton<String>(
                          value: _selectedMonth,
                          items: monthNumbers.map((String month) {
                            return DropdownMenuItem<String>(
                              value: month,
                              child: Text(month),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedMonth = newValue!;
                            });
                          },
                        ),
                      ],
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
            DropdownButton<String>(
              value: _selectedDB,
              items:
                  ['SS', 'SS AB', 'SAP', 'ESIC', 'IPEAK'].map((String value) {
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
                  onPressed: () => _showConfirmationDialog('clean'),
                  child: const Text('Empty DB'),
                ),
                ElevatedButton(
                  onPressed: () => _showConfirmationDialog('update'),
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
