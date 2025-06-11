import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class DonXinNghiPhep extends StatefulWidget {
  const DonXinNghiPhep({super.key});

  @override
  State<DonXinNghiPhep> createState() => _DonXinNghiPhepState();
}

class _DonXinNghiPhepState extends State<DonXinNghiPhep> {
  List<dynamic> donNghiList = [];
  Map<int, String> bacSiNames = {};
  bool isLoading = false;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    fetchDonNghiPhep();
  }

  Future<void> fetchDonNghiPhep() async {
    setState(() => isLoading = true);
    try {
      final url = '${getBaseUrl()}api/NghiPhepBacSi';
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        donNghiList = jsonDecode(resp.body);
        for (var don in donNghiList) {
          final maBacSi = don['maBacSi'];
          if (!bacSiNames.containsKey(maBacSi)) {
            final bacSi = await fetchBacSi(maBacSi);
            bacSiNames[maBacSi] = bacSi['hoVaTen'] ?? 'Bác sĩ ID: $maBacSi';
          }
        }
        setState(() {});
      } else {
        setState(() => donNghiList = []);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không thể tải danh sách đơn nghỉ phép")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Có lỗi xảy ra: $error")));
    }
    setState(() => isLoading = false);
  }

  Future<Map<String, dynamic>> fetchBacSi(int maBacSi) async {
    try {
      final url = '${getBaseUrl()}api/BacSi/$maBacSi';
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body);
      }
    } catch (error) {
      debugPrint("Lỗi khi lấy thông tin bác sĩ $maBacSi: $error");
    }
    return {'hoVaTen': null};
  }

  Future<void> updateDonNghiPhep(int maNghiPhep, String trangThai) async {
    try {
      setState(() => isLoading = true);
      final url = '${getBaseUrl()}api/NghiPhepBacSi/$maNghiPhep';

      // Tìm đơn nghỉ phép trong donNghiList
      final don = donNghiList.firstWhere(
        (d) => d['maNghiPhep'] == maNghiPhep,
        orElse: () => null,
      );

      if (don == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Không tìm thấy đơn nghỉ phép")));
        setState(() => isLoading = false);
        return;
      }

      // Tạo body đầy đủ từ dữ liệu đơn hiện tại
      final body = {
        "maNghiPhep": don['maNghiPhep'],
        "maBacSi": don['maBacSi'],
        "ngayBatDau": don['ngayBatDau'],
        "ngayKetThuc": don['ngayKetThuc'],
        "ghiChu": don['ghiChu'],
        "trangThai": trangThai,
        "ngayTao": don['ngayTao'],
      };

      final resp = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      debugPrint("PUT Response status: ${resp.statusCode}");
      debugPrint("PUT Response body: ${resp.body}");

      setState(() => isLoading = false);

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cập nhật trạng thái đơn thành công!")),
        );
        fetchDonNghiPhep();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Cập nhật trạng thái thất bại: ${resp.statusCode} - ${resp.body}",
            ),
          ),
        );
      }
    } catch (error) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Có lỗi xảy ra: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quản Lý Đơn Nghỉ Phép",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF0165FC),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFF0165FC)),
              )
              : donNghiList.isEmpty
              ? Center(
                child: Text(
                  "Chưa có đơn nghỉ phép nào.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
              : RefreshIndicator(
                onRefresh: fetchDonNghiPhep,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: donNghiList.length,
                  itemBuilder: (context, index) {
                    final don = donNghiList[index];
                    final maBacSi = don['maBacSi'];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bác sĩ: ${bacSiNames[maBacSi] ?? 'Đang tải...'}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0165FC),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Từ: ${dateFormat.format(DateTime.parse(don['ngayBatDau']))} - Đến: ${dateFormat.format(DateTime.parse(don['ngayKetThuc']))}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Trạng thái: ${don['trangThai']}",
                              style: TextStyle(
                                fontSize: 15,
                                color:
                                    don['trangThai'] == "Chờ duyệt"
                                        ? Colors.orange
                                        : don['trangThai'] == "Đã duyệt"
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (don['ghiChu'] != null &&
                                don['ghiChu'].isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  "Ghi chú: ${don['ghiChu']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            if (don['trangThai'] == "Chờ duyệt") ...[
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        () => updateDonNghiPhep(
                                          don['maNghiPhep'],
                                          "Đã duyệt",
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                    ),
                                    child: Text(
                                      "Duyệt",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed:
                                        () => updateDonNghiPhep(
                                          don['maNghiPhep'],
                                          "Từ chối",
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                    ),
                                    child: Text(
                                      "Từ chối",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
