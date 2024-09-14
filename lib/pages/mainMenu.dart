//kode ke-1
/*
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_qi_apps/auth/auth_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../auth/db_service.dart';
import '../config/config.dart';
import 'page_menu_sap.dart'; // Pastikan ini mengarah ke file yang benar
import 'page_menu_ss.dart';
import 'page_menu_ipeak.dart';
import 'page_menu_jarvis.dart';
import 'page_menu_ssab.dart';
import '../auth/login_page.dart'; // Sesuaikan dengan path halaman login

// Ambil token yang disimpan

class CardExample extends StatefulWidget {
  const CardExample({super.key});

  @override
  _CardExampleState createState() => _CardExampleState();
}

class _CardExampleState extends State<CardExample> {
  bool _isDarkMode = false; // Variabel untuk dark mode
  List<Map> values = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QI Dasbboard Apps'),
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
                MaterialPageRoute(
                    builder: (context) =>
                        const LoginPage()), // Arahkan ke halaman login
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Builder(builder: (context) {
                List<Map> values = [
                  {
                    "label": "SS Acvh",
                    "value": 30,
                  },
                  {
                    "label": "Jarvis Acvh",
                    "value": 60,
                  },
                  {
                    "label": "Ipeak Acvh",
                    "value": 90,
                  },
                  {
                    "label": "EIICTM",
                    "value": 44,
                  },
                ];

                return LayoutBuilder(builder: (context, constraints) {
                  var w = constraints.maxWidth / 2;
                  var h = constraints.maxHeight / 2;
                  return Wrap(
                    children: List.generate(values.length, (index) {
                      double value = double.parse("${values[index]["value"]}");
                      String label = values[index]["label"];

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
                            //speedometer 1/2 dengan multiple range dengan syncfusion_flutter_gauges ?
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 20.0,
                              ),
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
                                margin: const EdgeInsets.only(
                                  bottom: 10.0,
                                ),
                                child: Text(
                                  "$value %",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.034,
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
                });
              }),
            ),
          ),
          Expanded(
            child: SizedBox(
                child: FutureBuilder<List<dynamic>>(
                    future: _fecthDataUsers(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Data tidak ditemukan'));
                      } else {
                        return ListView.builder(
                          itemCount: 3,
                          scrollDirection: Axis.horizontal,
                          physics: const ScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            List colors = [
                              Colors.red,
                              Colors.green,
                              Colors.blue
                            ];
                            Color color = colors[index];
                            return Card(
                              child: Builder(
                                builder: (context) {
                                  final List<Map> chartData = [
                                    {
                                      "year": "Mobile",
                                      "sales": 10,
                                    },
                                    {
                                      "year": "LCE",
                                      "sales": 10,
                                    },
                                    {
                                      "year": "MTE",
                                      "sales": 10,
                                    },
                                    {
                                      "year": "PSC",
                                      "sales": 10,
                                    },
                                    {
                                      "year": "Big Whell",
                                      "sales": 10,
                                    },
                                    {
                                      "year": "Lighting",
                                      "sales": 10,
                                    },
                                    {
                                      "year": "PCH",
                                      "sales": 10,
                                    },
                                    {
                                      "year": "Pumping",
                                      "sales": 10,
                                    }
                                  ];

                                  return Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.94,
                                    color: Theme.of(context).cardColor,
                                    padding: const EdgeInsets.all(0.0),
                                    child: SfCartesianChart(
                                      isTransposed: true,
                                      title: const ChartTitle(
                                        text: 'Sales by year',
                                      ),
                                      primaryXAxis: const CategoryAxis(
                                        //tampilkan semua label x?
                                        labelIntersectAction:
                                            AxisLabelIntersectAction.rotate45,
                                        // title: AxisTitle(text: 'Sales'),
                                        // opposedPosition: true,
                                      ),
                                      primaryYAxis: const NumericAxis(
                                        title: AxisTitle(text: 'Acvh (%)'),
                                      ),
                                      // legend: const Legend(
                                      //   isVisible: true,
                                      //   position: LegendPosition.bottom,
                                      // ),
                                      series: <CartesianSeries>[
                                        BarSeries<Map, String>(
                                          dataSource: chartData,
                                          color: color,
                                          xValueMapper: (Map data, _) =>
                                              data["label"],
                                          yValueMapper: (Map data, _) =>
                                              data["value"],
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true),
                                        )
                                      ],
                                    ),
                                  );
                                }, //builder
                              ),
                            );
                          },
                        );
                      }
                    })),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 1.0 / 0.4,
            padding: const EdgeInsets.all(10),
            children: [
              _buildCard(context, 'SS', const PageSS()),
              _buildCard(context, 'SAP', const PageMenuSAP()),
              _buildCard(context, 'Ipeak', const PageIpeak()),
              _buildCard(context, 'Jarvis', const PageJarvis()),
              _buildCard(context, 'SS AB', const PageSSAB()),
              _buildCard(context, 'KPI QI', const PageSSAB()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget page) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }

  String _buildApiUrl() {
    return "http://$apiIP:$apiPort/api/ss-all-plt2";
  }

  String crew = "";
  Future<List<dynamic>> _fecthDataUsers() async {
    // Ambil token yang disimpan

    String apiUrl = _buildApiUrl();
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
      // Jika terjadi kesalahan pada permintaan HTTP, lemparkan Exception
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
  bool _isDarkMode = false; // Variabel untuk dark mode

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Tema terang
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Tema gelap
      ),
      home: const CardExample(), // Panggil CardExample
    );
  }

  // Function untuk toggle dark mode
  void toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  String? getToken() {
    return DBService.get("token");
  }
}

void main() {
  runApp(const MyApp());
}
*/

//kode ke-2
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:new_qi_apps/auth/auth_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../auth/db_service.dart';
import '../config/config.dart';
import 'page_menu_sap.dart';
import 'page_menu_ss.dart';
import 'page_menu_ipeak.dart';
import 'page_menu_jarvis.dart';
import 'page_menu_ssab.dart';
import '../auth/login_page.dart';

// Ambil token yang disimpan

class CardExample extends StatefulWidget {
  const CardExample({super.key});

  @override
  _CardExampleState createState() => _CardExampleState();
}

class _CardExampleState extends State<CardExample> {
  bool _isDarkMode = false; // Variabel untuk dark mode
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
        title: const Text('QI Dasbboard Apps'),
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
        ],
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
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20.0),
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
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        "$value %",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.034,
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
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fecthDataUsersChartBar(),
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

                  return ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      List colors = [Colors.red, Colors.green, Colors.blue];
                      Color color = colors[index];

                      return Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.94,
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(0.0),
                          child: SfCartesianChart(
                            isTransposed: true,
                            title: const ChartTitle(text: 'Sales by year'),
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
                                color: color,
                                xValueMapper: (Map data, _) => data["label"],
                                yValueMapper: (Map data, _) => data["value"],
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
              _buildCard(context, 'SAP', const PageMenuSAP()),
              _buildCard(context, 'Ipeak', const PageIpeak()),
              _buildCard(context, 'Jarvis', const PageJarvis()),
              _buildCard(context, 'SS AB', const PageSSAB()),
              _buildCard(context, 'KPI QI', const PageSSAB()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget page) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        child: SizedBox(
          width: 100,
          height: 100,
          child: Center(child: Text(title)),
        ),
      ),
    );
  }

  String crew = "";

  Future<List<dynamic>> _fecthDataUsersChartBar() async {
    String apiUrl = "http://$apiIP:$apiPort/api/ss-all-plt2";
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
      home: const CardExample(),
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
