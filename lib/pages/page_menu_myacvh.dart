import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:new_qi_apps/auth/auth_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../auth/db_service.dart';
import '../config/config.dart';
import 'page_menu_myacvh.dart';
import 'page_menu_sap.dart';
import 'page_menu_ss.dart';
import 'page_menu_ipeak.dart';
import 'page_menu_jarvis.dart';
import 'page_menu_ssab.dart';
import '../auth/login_page.dart';

// Ambil token yang disimpan

class PageMyAcvh extends StatefulWidget {
  const PageMyAcvh({super.key});

  @override
  _PageMyAcvhState createState() => _PageMyAcvhState();
}

class _PageMyAcvhState extends State<PageMyAcvh> {
  final bool _isDarkMode = false; // Variabel untuk dark mode
  List<Map<String, dynamic>> values = [];

  @override
  void initState() {
    super.initState();
    _fecthDataUsersChartBar();
    _fecthDataUsersChartKPI(); // Fetch data saat state diinisialisasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dasbboard Acvh'),
        /*
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              setState(() {
                _isDarkMode =
                    !_isDarkMode; // Toggle antara dark mode dan light mode
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],*/
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FutureBuilder<List<dynamic>>(
                future: _fecthDataUsersChartKPI(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Data tidak ditemukan'));
                  } else if (snapshot.hasData) {
                    List<Map<String, dynamic>> chartData =
                        snapshot.data!.map((item) {
                      return {
                        "label": item['label'],
                        "value": double.parse(item['value']),
                      };
                    }).toList();

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        var w = constraints.maxWidth / 2;
                        var h = constraints.maxHeight / 2;
                        return Wrap(
                          children: List.generate(chartData.length, (index) {
                            double value = chartData[index]["value"];
                            String label = chartData[index]["label"];

                            List<Color> colors = [
                              Colors.red,
                              Colors.orange,
                              Colors.green,
                            ];

                            if (label == "PSC") {
                              colors = [
                                Colors.green,
                                Colors.orange,
                                Colors.red,
                              ];
                            }

                            return SizedBox(
                              height: h,
                              width: w,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      label,
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 40.0),
                                    child: SfRadialGauge(
                                      axes: <RadialAxis>[
                                        RadialAxis(
                                          minimum: 0,
                                          maximum: 150,
                                          showLabels: false,
                                          ranges: <GaugeRange>[
                                            GaugeRange(
                                                startValue: 0,
                                                endValue: 25,
                                                color: colors[0]),
                                            GaugeRange(
                                                startValue: 25,
                                                endValue: 100,
                                                color: colors[1]),
                                            GaugeRange(
                                                startValue: 100,
                                                endValue: 150,
                                                color: colors[2]),
                                          ],
                                          pointers: <GaugePointer>[
                                            NeedlePointer(value: value),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 90.0),
                                      child: Text(
                                        "$value %",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.044,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Tidak ada data'));
                  }
                },
              ),
            ),
          ),
          /*
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fecthDataUsersChartBar(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Data tidak ditemukan'));
                } else if (snapshot.hasData) {
                  // Data untuk masing-masing chart bar
                  List<Map<String, dynamic>> chartDataList = snapshot.data!;

                  return ListView.builder(
                    itemCount: chartDataList.length,
                    scrollDirection: Axis.horizontal,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      // Mengambil nilai `kpi` dan `response` dari data
                      String kpiTitle =
                          chartDataList[index]["kpi"]; // Mengambil nilai `kpi`
                      List<Map<String, dynamic>> chartData =
                          chartDataList[index]["response"];

                      return Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.94,
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(0.0),
                          child: SfCartesianChart(
                            isTransposed: true,
                            title: ChartTitle(
                                text:
                                    kpiTitle), // Menggunakan nilai `kpi` sebagai judul
                            primaryXAxis: const CategoryAxis(
                              labelIntersectAction:
                                  AxisLabelIntersectAction.rotate45,
                            ),
                            primaryYAxis: const NumericAxis(
                              title: AxisTitle(text: 'Acvh (%)'),
                            ),
                            series: <CartesianSeries>[
                              BarSeries<Map<String, dynamic>, String>(
                                dataSource: chartData,
                                xValueMapper: (Map data, _) => data["label"],
                                yValueMapper: (Map data, _) =>
                                    double.parse(data["value"]),
                                pointColorMapper: (Map data, _) {
                                  // Memastikan nilai `value` dalam bentuk double
                                  double value = double.parse(data["value"]);

                                  // Mengatur warna berdasarkan kondisi nilai `value`
                                  if (value < 25) {
                                    return Colors
                                        .red; // Merah untuk nilai < 25%
                                  } else if (value >= 25 && value < 100) {
                                    return Colors
                                        .yellow; // Kuning untuk nilai antara 25% dan 100%
                                  } else {
                                    return Colors
                                        .green; // Hijau untuk nilai >= 100%
                                  }
                                },
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Tidak ada data'));
                }
              },
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 1.0 / 0.4,
            padding: const EdgeInsets.all(10),
            children: [
              _buildCard(context, 'SS', const PageSS()),
              _buildCard(context, 'Jarvis', const PageJarvis()),
              _buildCard(context, 'Ipeak', const PageIpeak()),
              _buildCard(context, 'SS AB', const PageSSAB()),
              _buildCard(context, 'SAP', const PageMenuSAP()),
              _buildCard(context, 'My Acvh', const PageMyAcvh()),
            ],
          ),*/
        ],
      ),
    );
  }

  String crew = "";
  Future<List<Map<String, dynamic>>> _fecthDataUsersChartBar() async {
    // URL untuk dua endpoint yang berbeda (ss-all-plt2 dan jarvis-all-plt2)
    String apiUrl1 = "http://$apiIP:$apiPort/api/ss-all-plt2";
    String apiUrl2 = "http://$apiIP:$apiPort/api/jarvis-all-plt2";
    String apiUrl3 =
        "http://$apiIP:$apiPort/api/ipeak-all-plt2"; // Uncomment jika ingin menambah

    // Membuat dua request API sekaligus dengan Future.wait
    var responses = await Future.wait([
      http.get(
        Uri.parse(apiUrl1),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      ),
      http.get(
        Uri.parse(apiUrl2),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      ),
      // Tambahkan kembali jika menggunakan API ketiga
      http.get(
        Uri.parse(apiUrl3),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      ),
    ]);

    // Cek status code dari masing-masing response
    if (responses[0].statusCode == 200 &&
        responses[1].statusCode == 200 &&
        responses[2].statusCode == 200) {
      // Decode response body menjadi objek JSON
      var data1 = json.decode(responses[0].body);
      var data2 = json.decode(responses[1].body);
      var data3 =
          json.decode(responses[2].body); // Uncomment jika ingin menambah

      // Return list yang berisi `kpi` dan `response` untuk masing-masing API
      return [
        {
          "kpi": data1['kpi'],
          "response": List<Map<String, dynamic>>.from(data1['response'])
        },
        {
          "kpi": data2['kpi'],
          "response": List<Map<String, dynamic>>.from(data2['response'])
        },
        // Tambahkan kembali jika menggunakan API ketiga
        {
          "kpi": data3['kpi'],
          "response": List<Map<String, dynamic>>.from(data3['response'])
        }
      ];
    } else {
      throw Exception('Failed to load data from one or more endpoints');
    }
  }

  Future<List<dynamic>> _fecthDataUsersChartKPI() async {
    String apiUrl = "http://$apiIP:$apiPort/api/all-kpi";
    var result = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken', // Menyertakan token ke header
      },
    );

    if (result.statusCode == 200) {
      var obj = json.decode(result.body);
      crew = obj["crew"];
      //print(obj['response']);
      return obj['response'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const PageMyAcvh(),
    );
  }

  void toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
}

void main() {
  runApp(const MyApp());
}