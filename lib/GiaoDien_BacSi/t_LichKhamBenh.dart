import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class LichKhamBenhBacSi extends StatefulWidget {
  final int maBacSi;
  const LichKhamBenhBacSi({super.key, required this.maBacSi});

  @override
  State<LichKhamBenhBacSi> createState() => _LichKhamBenhBacSiState();
}

class _LichKhamBenhBacSiState extends State<LichKhamBenhBacSi> {
  List<dynamic> _lichKham = [];
  bool _loading = true;
  String _filter = "Chưa khám"; // Bộ lọc mặc định

  @override
  void initState() {
    super.initState();
    _fetchLichKham();
  }

  Future<void> _fetchLichKham() async {
    final url = "${getBaseUrl()}api/LichKham/BacSi/${widget.maBacSi}";
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      setState(() {
        _lichKham = jsonDecode(resp.body);
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _xacNhanDaKham(int maLichKham) async {
    final url = "${getBaseUrl()}api/LichKham/XacNhanDaKham/$maLichKham";
    final resp = await http.put(Uri.parse(url));
    if (resp.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Đã xác nhận đã khám!")));
      _fetchLichKham();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Xác nhận thất bại!")));
    }
  }

  bool _isQuaThoiGianKham(String thoiGianKham) {
    try {
      final dt = DateTime.parse(thoiGianKham);
      return DateTime.now().isAfter(dt);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách theo trạng thái đúng logic
    final filtered =
        _lichKham.where((item) {
          final trangThaiTT = item['trangThaiTT'] ?? '';
          final trangThaiKham = item['trangThaiKham'] ?? '';
          if (_filter == "Chưa khám") {
            return trangThaiTT == "Đã thanh toán" &&
                trangThaiKham == "Chưa khám";
          } else if (_filter == "Đã khám") {
            return trangThaiTT == "Đã thanh toán" && trangThaiKham == "Đã khám";
          }
          return false;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách lịch được đặt",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0165FC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _filter = "Chưa khám";
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                _filter == "Chưa khám"
                                    ? Colors.white
                                    : Colors.blue,
                            backgroundColor:
                                _filter == "Chưa khám"
                                    ? Colors.blue
                                    : Colors.transparent,
                          ),
                          child: Text("Lịch chưa khám"),
                        ),
                        SizedBox(width: 12),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _filter = "Đã khám";
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                _filter == "Đã khám"
                                    ? Colors.white
                                    : Colors.blue,
                            backgroundColor:
                                _filter == "Đã khám"
                                    ? Colors.blue
                                    : Colors.transparent,
                          ),
                          child: Text("Lịch đã khám"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        filtered.isEmpty
                            ? Center(child: Text("Không có lịch khám nào!"))
                            : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                final hoSo = item['hoSoBenhNhan'];
                                final String trangThai =
                                    item['trangThai'] ?? '';
                                final String thoiGianKham =
                                    item['thoiGianKham'] ?? '';
                                final bool quaThoiGian = _isQuaThoiGianKham(
                                  thoiGianKham,
                                );

                                return Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Colors.blue[100],
                                          child: Icon(
                                            Icons.calendar_today,
                                            size: 32,
                                            color: Colors.blue[700],
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                hoSo?['hoVaTen'] ?? "Bệnh nhân",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue[900],
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_month,
                                                    size: 18,
                                                    color: Colors.grey[600],
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "Ngày: ${thoiGianKham.substring(0, 10)}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 18,
                                                    color: Colors.grey[600],
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    thoiGianKham.length >= 16
                                                        ? thoiGianKham
                                                            .substring(11, 16)
                                                        : "",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  if (_filter == "Chưa khám" &&
                                                      quaThoiGian)
                                                    TextButton.icon(
                                                      icon: Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                      ),
                                                      label: Text(
                                                        "Xác nhận đã khám",
                                                      ),
                                                      style:
                                                          TextButton.styleFrom(
                                                            foregroundColor:
                                                                Colors.green,
                                                            textStyle:
                                                                TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                      onPressed: () async {
                                                        await _xacNhanDaKham(
                                                          item['maLichKham'],
                                                        );
                                                      },
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.info,
                                            color: Colors.blue,
                                          ),
                                          tooltip: "Xem chi tiết",
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Thông tin bệnh nhân",
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Họ tên: ${hoSo?['hoVaTen'] ?? ''}",
                                                      ),
                                                      Text(
                                                        "Ngày sinh: ${hoSo?['ngaySinh']?.substring(0, 10) ?? ''}",
                                                      ),
                                                      Text(
                                                        "Giới tính: ${hoSo?['gioiTinh'] ?? ''}",
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Đóng"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
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
