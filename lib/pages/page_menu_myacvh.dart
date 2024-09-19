import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../auth/auth_service.dart';
import '../auth/db_service.dart';
import '../config/config.dart';

class PageMenuMyacvh extends StatefulWidget {
  const PageMenuMyacvh({super.key});

  @override
  _PageMenuMyacvh createState() => _PageMenuMyacvh();
}

class _PageMenuMyacvh extends State<PageMenuMyacvh> {
  late Future<Map<String, dynamic>> futureKPIData;
  late Future<List<Map<String, dynamic>>> futureBarData;
  String? nrp = "";

  @override
  void initState() {
    super.initState();
    DBService.init();
    _loadNRP();
    futureKPIData = _fetchDataUsersChartKPI();
    futureBarData = _fetchDataUsersChartBar();
  }

  Future<void> _loadNRP() async {
    setState(() {
      nrp = DBService.get("nrp");
      //print('fcm login :  $fcmToken');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My KPI Board Acvh",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Text(
            nama,
            style: const TextStyle(
                fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FutureBuilder<Map<String, dynamic>>(
                future: futureKPIData,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Data tidak ditemukan'));
                  } else if (snapshot.hasData) {
                    var data = snapshot.data;
                    List<Map<String, dynamic>> chartData =
                        (data?['data'] as List<dynamic>).map((item) {
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

                            List<GaugeRange> ranges = [
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
                            ];

                            // Jika label adalah "SAP Acvh", ubah warna dan range
                            if (label == "SAP Acvh") {
                              colors = [
                                Colors.red,
                                Colors.green,
                              ];
                              ranges = [
                                GaugeRange(
                                    startValue: 0,
                                    endValue: 70,
                                    color: colors[0]),
                                GaugeRange(
                                    startValue: 70,
                                    endValue: 100,
                                    color: colors[1]),
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
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20.0),
                                    child: SfRadialGauge(
                                      axes: <RadialAxis>[
                                        RadialAxis(
                                          minimum: 0,
                                          maximum: label == "SAP Acvh"
                                              ? 100
                                              : 150, // Atur maksimum sesuai label
                                          showLabels: false,
                                          ranges:
                                              ranges, // Gunakan range yang telah diubah
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: futureBarData,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Data tidak ditemukan'));
                } else if (snapshot.hasData) {
                  List<Map<String, dynamic>> chartDataList = snapshot.data!;

                  return ListView.builder(
                    itemCount: chartDataList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      String kpiTitle = "SS Yearly 2024";
                      List<Map<String, dynamic>> chartData =
                          chartDataList[index]["barChart"];

                      return Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.94,
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(0.0),
                          child: SfCartesianChart(
                            isTransposed: true,
                            title: ChartTitle(text: kpiTitle),
                            primaryXAxis: const CategoryAxis(
                              labelIntersectAction:
                                  AxisLabelIntersectAction.rotate45,
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: (kpiTitle == "SS Yearly 2024")
                                    ? 'Jumlah SS'
                                    : 'Acvh (%)',
                              ),
                            ),
                            series: <CartesianSeries>[
                              BarSeries<Map<String, dynamic>, String>(
                                dataSource: chartData,
                                xValueMapper: (Map data, _) => data["label"],
                                yValueMapper: (Map data, _) =>
                                    double.parse(data["value"]),
                                pointColorMapper: (Map data, _) {
                                  double value = double.parse(data["value"]);
                                  if (value < 5) {
                                    return Colors.red;
                                  } else {
                                    return Colors.green;
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
          const SizedBox(
            height: 20,
          ),
          Text('Update : $update'),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  String update = "";
  String nama = "";

  Future<List<Map<String, dynamic>>> _fetchDataUsersChartBar() async {
    String apiUrl1 = "http://$apiIP:$apiPort/api/all-data/$nrp";

    var responses = await Future.wait([
      http.get(Uri.parse(apiUrl1),
          headers: {'Authorization': 'Bearer $userToken'}),
    ]);

    if (responses.every((response) => response.statusCode == 200)) {
      return [
        {
          "kpi": json.decode(responses[0].body)['kpi'],
          "barChart": List<Map<String, dynamic>>.from(
              json.decode(responses[0].body)['barChart']),
        },
      ];
    } else {
      throw Exception('Failed to load data from one or more endpoints');
    }
  }

  Future<Map<String, dynamic>> _fetchDataUsersChartKPI() async {
    String apiUrl = "http://$apiIP:$apiPort/api/all-data/$nrp";
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      //print(decodedData);

      // Extract update value
      if (decodedData.containsKey('update') &&
          decodedData['update'] is String) {
        update = decodedData['update'];
        nama = decodedData['name'];
        //print(update);
        setState(() {}); // Memicu pembaruan UI
      }

      // Check if 'response' key exists and holds a list
      if (decodedData.containsKey('response') &&
          decodedData['response'] is List) {
        List<Map<String, dynamic>> chartData =
            (decodedData['response'] as List).map((item) {
          return {
            "label": item['label'] ?? '', // Provide default values if needed
            "value": item['value'] ?? '',
          };
        }).toList();
        //print(chartData);
        return {'data': chartData};
      } else {
        // Handle the case where 'data' is missing or not a list
        //print("API response doesn't have a 'data' list or 'data' is null");
        return {'data': []}; // Return an empty list to avoid errors
      }
    } else {
      throw Exception('Failed to load KPI data');
    }
  }
}
