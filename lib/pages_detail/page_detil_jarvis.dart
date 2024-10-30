/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth_service.dart';
import '../config/config.dart'; // Import file config.dart

class PageDetilJarvis extends StatelessWidget {
  final String nrp; // Tambahkan deklarasi nrp
  const PageDetilJarvis({super.key, required this.nrp}); // Perbaiki konstruktor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Judul Doc'),
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
                  title: Text(snapshot.data![index]['
                  ']),
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

  // Fungsi untuk mengambil update terakhir dari API
  Future<String> _fetchLastUpdateData() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/jarvis/$nrp";

    try {
      var result = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Menyertakan token ke header
        },
      );

      // Parsing hasil body
      var data = json.decode(result.body);
      print(data);

      // Cek apakah data atau field 'update' bernilai null
      if (data == null || data['update'] == null) {
        return "No Data";
      }

      return data['update'];
    } catch (error) {
      // Handle error, misalnya return "No Data" atau error lainnya
      return "No Data"; // Mengembalikan "No Data" jika terjadi error
    }
  }

  Future<String> _fecthDataUsers() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/jarvis/$nrp";

    try {
      var result = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Menyertakan token ke header
        },
      );

      // Parsing hasil body
      var data = json.decode(result.body);
      print(data);

      // Cek apakah data atau field 'update' bernilai null
      if (data == null || data['judul'] == null) {
        return "No Data";
      }

      return data['judul'];
    } catch (error) {
      // Handle error, misalnya return "No Data" atau error lainnya
      return "No Data"; // Mengembalikan "No Data" jika terjadi error
    }
  }

/*
  Future<List<dynamic>> _fecthDataUsers() async {
    final String apiUrl =
        "http://$apiIP:$apiPort/api/jarvis/$nrp"; // Gunakan data NRP yang diterima
    var result = await http.get(Uri.parse(apiUrl));
    print(json.decode(result.body));
    return json.decode(result.body)['judul'];
  }

  Future<String> _fetchLastUpdateData() async {
    final String apiUrl = "http:///$apiIP:$apiPort/api/jarvis/$nrp";
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['update'];
  }
*/
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

*/
/*
//kode ke-2
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth_service.dart';
import '../config/config.dart'; // Import file config.dart
import '../auth/db_service.dart';

class PageDetilJarvis extends StatelessWidget {
  final String nrp;
  //final String jarvisAchv;
  //final String judulDoc;

  const PageDetilJarvis({
    super.key,
    required this.nrp,
  }); // Perbaiki konstruktor

  String jarvisAchv;
  String judulDoc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Ubah title untuk menggunakan nama dari DBService
          title: FutureBuilder<String?>(
            future:
                _fetchUserName(), // Fungsi untuk mengambil nama dari DBService
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                    'Loading...'); // Tampilkan loading saat menunggu
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return const Text('Unknown'); // Jika gagal atau nama kosong
              } else {
                return Text(snapshot
                    .data!); // Tampilkan nama yang diambil dari DBService
              }
            },
          ),
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
        /*
      body: FutureBuilder<List<dynamic>>(
        future: _fetchDataUsers(),
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
                  title: Text(snapshot.data![index]['judul']),
                  subtitle: Text(
                    'Status : ${snapshot.data![index]['status']}\nCreated : ${snapshot.data![index]['create']}',
                  ),
                );
              },
            );
          }
        },
      ), */
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: _getAvatarColor(jarvisAchv),
                  //color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    jarvisAchv,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ));
  }

  // Fungsi untuk mengambil data pengguna dari API
  Future<List<dynamic>> _fetchDataUsers() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/jarvis/$nrp";

    try {
      var result = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Menyertakan token ke header
        },
      );

      // Parsing hasil body
      var data = json.decode(result.body);

      // Pastikan respons memiliki data yang sesuai
      if (data != null && data['response'] != null) {
        //print(data['response']);

        return data['response'];
      } else {
        // Kembalikan array kosong jika tidak ada data 'response'

        return [];
      }
    } catch (error) {
      // Tangani error dengan log atau melakukan tindakan lain
      print("Error fetching data: $error");
      // Kembalikan array kosong jika terjadi error

      return [];
    }
  }

  // Fungsi untuk mengambil update terakhir dari API
  Future<String> _fetchLastUpdateData() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/jarvis/$nrp";

    try {
      var result = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Menyertakan token ke header
        },
      );

      // Parsing hasil body
      var data = json.decode(result.body);

      // Cek apakah data atau field 'update' bernilai null
      if (data == null || data['update'] == null) {
        return "No Data";
      }

      return data['update'];
    } catch (error) {
      // Handle error, misalnya return "No Data" atau error lainnya
      return "No Data"; // Mengembalikan "No Data" jika terjadi error
    }
  }

  // Fungsi untuk mendapatkan nama pengguna dari DBService
  Future<String?> _fetchUserName() async {
    return DBService.get("nama"); // Mengambil nama dari SharedPreferences
  }

  // Fungsi untuk menentukan warna avatar berdasarkan jumlah SS
  /*
  Color _getAvatarColor(int jmlDoc) {
    if (jmlDoc < 1) {
      return Colors.redAccent;
    } else {
      return Colors.lightGreen;
    }
  }
  */

  Color _getAvatarColor(dynamic achvJarvis) {
    if (achvJarvis == null) {
      return Colors.red;
    } else if (achvJarvis is String) {
      // Coba untuk mengonversi nilai string menjadi double
      final int? achvJarvisInt = int.tryParse(achvJarvis);
      if (achvJarvisInt == null) {
        // Jika gagal mengonversi, kembalikan warna merah
        return Colors.red;
      }
      achvJarvis = achvJarvisInt; // Gunakan nilai double yang sudah diubah
    }
    // Sekarang sap pasti bertipe double, lanjutkan dengan logika seperti sebelumnya
    if (achvJarvis < 1) {
      return Colors.redAccent;
    } else {
      return Colors.lightGreen;
    }
  }
}
*/
/*
//kode ke-3
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth_service.dart';
import '../config/config.dart'; // Import file config.dart

class PageDetilJarvis extends StatefulWidget {
  final String nrp; // Tetap final karena ini diterima dari luar

  const PageDetilJarvis({super.key, required this.nrp});

  @override
  _PageDetilJarvisState createState() => _PageDetilJarvisState();
}

class _PageDetilJarvisState extends State<PageDetilJarvis> {
  String nama = "Loading...";
  int jarvisAchv = 0;
  String lastUpdate = "Loading...";
  String nrp = "Loading...";

  @override
  void initState() {
    super.initState();
    nrp = widget.nrp;
    _fetchDataUsers(); // Ambil data ketika widget diinisialisasi
  }

  // Fungsi untuk mengambil data pengguna dari API
  Future<void> _fetchDataUsers() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/jarvis/${widget.nrp}";
    //print(apiUrl);
    try {
      var result = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Menyertakan token ke header
        },
      );

      // Parsing hasil body
      var data = json.decode(result.body);

      // Pastikan respons memiliki data yang sesuai
      if (data != null && data['response'] != null) {
        print(data);
        setState(() {
          // Update state dengan data dari API
          nama = data['nama'] ?? 'Unknown';
          jarvisAchv = int.tryParse(data['response']['doc']) ?? 0;
          lastUpdate = data['update'] ?? 'No Data';
        });
      } else {
        // Jika respons tidak ada data, set default value
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
        title: const Text("Jarvis Achv"), // Menampilkan nama dari data
        centerTitle: true,
        /*
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Text(lastUpdate),
        ),*/
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: _getAvatarColor(jarvisAchv),
                //color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  jarvisAchv.toString(),
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            //sisipkan di sini
            const SizedBox(height: 120),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Last update : \n$lastUpdate',
                  style: const TextStyle(
                    fontSize: 20,
                    //color: Colors.blue,
                    //fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(dynamic jarvis) {
    if (jarvis == null) {
      return Colors.red;
    } else if (jarvis is String) {
      // Coba untuk mengonversi nilai string menjadi double
      final int? jarvisInt = int.tryParse(jarvis);
      if (jarvisInt == null) {
        // Jika gagal mengonversi, kembalikan warna merah
        return Colors.red;
      }
      jarvis = jarvisInt; // Gunakan nilai double yang sudah diubah
    }
    // Sekarang sap pasti bertipe double, lanjutkan dengan logika seperti sebelumnya
    if (jarvis < 1) {
      return Colors.redAccent;
    } else {
      return Colors.green;
    }
  }
}
*/

//kode ke-4
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth_service.dart';
import '../config/config.dart'; // Import file config.dart

class PageDetilJarvis extends StatefulWidget {
  final String nrp; // Tetap final karena ini diterima dari luar

  const PageDetilJarvis({super.key, required this.nrp});

  @override
  _PageDetilJarvisState createState() => _PageDetilJarvisState();
}

class _PageDetilJarvisState extends State<PageDetilJarvis> {
  String nama = "Loading...";
  int jarvisAchv = 0;
  String lastUpdate = "Loading...";
  String nrp = "Loading...";
  List<String> judulList = []; // Tambahkan untuk menyimpan daftar judul

  @override
  void initState() {
    super.initState();
    nrp = widget.nrp;
    _fetchDataUsers(); // Ambil data ketika widget diinisialisasi
  }

  // Fungsi untuk mengambil data pengguna dari API
  Future<void> _fetchDataUsers() async {
    final String apiUrl = "http://$apiIP:$apiPort/api/jarvis/${widget.nrp}";
    try {
      var result = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Menyertakan token ke header
        },
      );

      // Parsing hasil body
      var data = json.decode(result.body);

      // Pastikan respons memiliki data yang sesuai
      if (data != null && data['response'] != null) {
        setState(() {
          // Update state dengan data dari API
          nama = data['nama'] ?? 'Unknown';
          jarvisAchv = int.tryParse(data['response']['doc']) ?? 0;
          lastUpdate = data['update'] ?? 'No Data';
          judulList = data['response']['judul'].split('|'); // Update judulList
        });
      } else {
        // Jika respons tidak ada data, set default value
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 80,
              height: 80,
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
            const SizedBox(height: 10),
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
              ],
            ),
            const Text("Judul yang telah dibaca",
                style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: judulList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 15.0),
                    child: Text(
                      '${index + 1}. ${judulList[index]}', // Tambahkan nomor urut di depan judul
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Last update : \n$lastUpdate',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
}
