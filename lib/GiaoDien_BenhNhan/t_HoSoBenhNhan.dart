import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 't_TaoMoiHoSoBenhNhan.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class HoSoBenhNhanScreen extends StatefulWidget {
  final int maNguoiDung;
  const HoSoBenhNhanScreen({super.key, required this.maNguoiDung});

  @override
  State<HoSoBenhNhanScreen> createState() => _HoSoBenhNhanScreenState();
}

class _HoSoBenhNhanScreenState extends State<HoSoBenhNhanScreen> {
  late Future<List<Map<String, dynamic>>> _futureProfiles;

  @override
  void initState() {
    super.initState();
    _futureProfiles = fetchProfiles(widget.maNguoiDung);
  }

  Future<List<Map<String, dynamic>>> fetchProfiles(int maNguoiDung) async {
    final url = '${getBaseUrl()}api/HoSoBenhNhan/NguoiDung/$maNguoiDung';

    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data is Map) {
        return [data as Map<String, dynamic>];
      } else {
        throw Exception('Dữ liệu không hợp lệ');
      }
    } else {
      throw Exception('Không thể tải dữ liệu (${resp.statusCode})');
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return "";
    try {
      final dt = DateTime.parse(date.toString());
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year}";
    } catch (_) {
      return date.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0165FC),
        title: const Text(
          "Hồ sơ bệnh nhân",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureProfiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Lỗi: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final danhSachHoSo = snapshot.data ?? [];

          if (danhSachHoSo.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Bạn chưa có hồ sơ bệnh nhân. Vui lòng tạo mới hồ sơ để đặt khám.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0165FC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TaoHoSoBenhNhanScreen(
                                  maNguoiDung: widget.maNguoiDung,
                                ),
                          ),
                        ).then((value) {
                          setState(() {
                            _futureProfiles = fetchProfiles(widget.maNguoiDung);
                          });
                        });
                      },
                      icon: const Icon(
                        Icons.person_add_alt,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Tạo hồ sơ mới",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0165FC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: danhSachHoSo.length,
                  itemBuilder: (context, index) {
                    final profile = danhSachHoSo[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(
                          profile["gioiTinh"] == "Nam"
                              ? Icons.person
                              : Icons.person_outline,
                          color: Colors.blueAccent,
                          size: 36,
                        ),
                        title: Text(
                          profile["hoVaTen"] ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ngày sinh: ${_formatDate(profile["ngaySinh"])}",
                            ),

                            Text("${profile["moiQuanHe"] ?? ""}"),
                          ],
                        ),

                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TaoHoSoBenhNhanScreen(
                                maNguoiDung: widget.maNguoiDung,
                              ),
                        ),
                      ).then((value) {
                        // Reload lại khi quay về (nếu có thêm mới)
                        setState(() {
                          _futureProfiles = fetchProfiles(widget.maNguoiDung);
                        });
                      });
                    },
                    icon: const Icon(Icons.person_add_alt, color: Colors.white),
                    label: const Text(
                      "Tạo hồ sơ mới",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0165FC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
