//kode ke-1

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_qi_apps/auth/auth_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../auth/db_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QI Apps'),
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
                    "label": "Mobile",
                    "value": 300,
                  },
                  {
                    "label": "LCE",
                    "value": 600,
                  },
                  {
                    "label": "MTE",
                    "value": 900,
                  },
                  {
                    "label": "PSC",
                    "value": 442,
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
                                    maximum: 1000,
                                    showLabels: false,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                          startValue: 0,
                                          endValue: 300,
                                          color: colors[0]),
                                      GaugeRange(
                                          startValue: 300,
                                          endValue: 700,
                                          color: colors[1]),
                                      GaugeRange(
                                          startValue: 700,
                                          endValue: 1000,
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
                                  "$value",
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
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  List colors = [Colors.red, Colors.green, Colors.blue];
                  Color color = colors[index];
                  return Card(
                    child: Builder(
                      builder: (context) {
                        final List<Map> chartData = [
                          {
                            "year": "Mobile",
                            "sales": 40,
                          },
                          {
                            "year": "LCE",
                            "sales": 90,
                          },
                          {
                            "year": "MTE",
                            "sales": 30,
                          },
                          {
                            "year": "PSC",
                            "sales": 80,
                          },
                          {
                            "year": "Big Whell",
                            "sales": 90,
                          },
                          {
                            "year": "Lighting",
                            "sales": 120,
                          },
                          {
                            "year": "PCH",
                            "sales": 80,
                          },
                          {
                            "year": "Pumping",
                            "sales": 90,
                          }
                        ];

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.94,
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
                              title: AxisTitle(text: 'Year'),
                            ),
                            // legend: const Legend(
                            //   isVisible: true,
                            //   position: LegendPosition.bottom,
                            // ),
                            series: <CartesianSeries>[
                              BarSeries<Map, String>(
                                dataSource: chartData,
                                color: color,
                                xValueMapper: (Map data, _) => data["year"],
                                yValueMapper: (Map data, _) => data["sales"],
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
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
