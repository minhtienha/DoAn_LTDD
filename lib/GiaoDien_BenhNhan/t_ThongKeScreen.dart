import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Hàm base URL, bạn có thể import hoặc copy lại
String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class ThongKeScreen extends StatefulWidget {
  final int userId;
  const ThongKeScreen({super.key, required this.userId});

  @override
  State<ThongKeScreen> createState() => _ThongKeScreenState();
}

class _ThongKeScreenState extends State<ThongKeScreen> {
  bool loading = true;
  String? error;

  List<dynamic> lichKhamList = [];
  List<dynamic> thanhToanList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final resp1 = await http.get(
        Uri.parse('${getBaseUrl()}api/LichKham?userId=${widget.userId}'),
      );
      final resp2 = await http.get(
        Uri.parse('${getBaseUrl()}api/ThanhToan?userId=${widget.userId}'),
      );
      if (resp1.statusCode == 200 && resp2.statusCode == 200) {
        lichKhamList = jsonDecode(resp1.body) as List;
        thanhToanList = jsonDecode(resp2.body) as List;
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          error = "Lỗi tải dữ liệu";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Lỗi: $e";
        loading = false;
      });
    }
  }

  // ---- Phân tích dữ liệu cho từng biểu đồ ----

  /// Số lượt khám bệnh, lượt đặt lịch theo tháng
  Map<String, int> getSoLuotKhamTheoThang() {
    Map<String, int> data = {};
    for (var item in lichKhamList) {
      String thang = item["thoiGianKham"].toString().substring(
        0,
        7,
      ); // "YYYY-MM"
      data[thang] = (data[thang] ?? 0) + 1;
    }
    return data;
  }

  /// Doanh thu theo tháng
  Map<String, int> getDoanhThuTheoThang() {
    Map<String, int> data = {};
    for (var item in thanhToanList) {
      String thang = item["ngayTao"].toString().substring(0, 7); // "YYYY-MM"
      //int soTien = (item["soTien"] ?? 0);
      int soTien = (item['soTien'] as num).toInt(); // Luôn ép kiểu an toàn

      data[thang] = (data[thang] ?? 0) + soTien;
    }
    return data;
  }

  /// Thống kê chuyên khoa (số lượt khám)
  Map<String, int> getChuyenKhoaStats() {
    Map<String, int> data = {};
    for (var item in lichKhamList) {
      final ck = item["bacSi"]?["chuyenKhoa"]?["tenChuyenKhoa"] ?? "Khác";
      data[ck] = (data[ck] ?? 0) + 1;
    }
    return data;
  }

  /// Thống kê bác sĩ (số lượt khám)
  Map<String, int> getBacSiStats() {
    Map<String, int> data = {};
    for (var item in lichKhamList) {
      final bs = item["bacSi"]?["hoVaTen"] ?? "Khác";
      data[bs] = (data[bs] ?? 0) + 1;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thống kê cá nhân"),
        backgroundColor: const Color(0xFF0165FC),
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text(error!))
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Biểu đồ cột số lượt khám
                      Text(
                        "Số lượt khám theo tháng",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final thang =
                                        getSoLuotKhamTheoThang().keys.toList();
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < thang.length) {
                                      return Text(
                                        thang[value.toInt()].substring(5),
                                      ); // chỉ MM
                                    }
                                    return Text('');
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            barGroups: [
                              ...getSoLuotKhamTheoThang().values
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => BarChartGroupData(
                                      x: e.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: e.value.toDouble(),
                                          width: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Biểu đồ đường doanh thu
                      Text(
                        "Doanh thu theo tháng",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final thang =
                                        getDoanhThuTheoThang().keys.toList();
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < thang.length) {
                                      return Text(
                                        thang[value.toInt()].substring(5),
                                      ); // chỉ MM
                                    }
                                    return Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: true,
                                spots: [
                                  ...getDoanhThuTheoThang().values
                                      .toList()
                                      .asMap()
                                      .entries
                                      .map(
                                        (e) => FlSpot(
                                          e.key.toDouble(),
                                          e.value.toDouble(),
                                        ),
                                      ),
                                ],
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Biểu đồ tròn chuyên khoa
                      Text(
                        "Tỉ lệ khám theo chuyên khoa",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections:
                                getChuyenKhoaStats().entries
                                    .map(
                                      (e) => PieChartSectionData(
                                        value: e.value.toDouble(),
                                        title: e.key,
                                        radius: 45,
                                      ),
                                    )
                                    .toList(),
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Biểu đồ tròn bác sĩ (bổ sung nếu muốn)
                      Text(
                        "Tỉ lệ khám theo bác sĩ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections:
                                getBacSiStats().entries
                                    .map(
                                      (e) => PieChartSectionData(
                                        value: e.value.toDouble(),
                                        title: e.key,
                                        radius: 40,
                                      ),
                                    )
                                    .toList(),
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
