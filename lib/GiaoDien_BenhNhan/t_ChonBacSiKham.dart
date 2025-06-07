import 'package:doan_nhom06/GiaoDien_BenhNhan/t_DatLichVoiBacSi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChonBacSiScreen extends StatefulWidget {
  final Map<String, dynamic> hoSo;
  const ChonBacSiScreen({super.key, required this.hoSo});

  @override
  State<ChonBacSiScreen> createState() => _ChonBacSiScreenState();
}

class _ChonBacSiScreenState extends State<ChonBacSiScreen> {
  String _selectedSpecialty = "Chuyên khoa";
  String _selectedGender = "Giới tính";

  static const baseUrl = "http://localhost:5001/api";
  List<String> chuyenKhoaList = [];
  List<Map<String, dynamic>> danhSachBacSi = [];
  bool loadingCK = true;
  List<String> gioiTinhList = ["Nam", "Nữ"];

  @override
  void initState() {
    super.initState();
    _loadChuyenKhoa();
    _loadBacSi();
  }

  // Tải danh sách chuyên khoa từ API
  Future<void> _loadChuyenKhoa() async {
    setState(() {
      loadingCK = true;
    });
    final resp = await http.get(Uri.parse("$baseUrl/ChuyenKhoa"));
    if (resp.statusCode == 200) {
      final js = jsonDecode(resp.body) as List;
      chuyenKhoaList =
          js
              .whereType<Map<String, dynamic>>()
              .where((m) => m.containsKey("tenChuyenKhoa"))
              .map((m) => m["tenChuyenKhoa"] as String)
              .toList();
    } else {
      throw Exception("Lỗi tải dữ liệu: ${resp.statusCode}");
    }
    setState(() {
      loadingCK = false;
    });
  }

  // Tải danh sách bác sĩ
  Future<void> _loadBacSi() async {
    final resp = await http.get(Uri.parse("$baseUrl/BacSi"));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as List;
      danhSachBacSi =
          data
              .map(
                (e) => {
                  "id": e["maBacSi"],
                  "ten": e["hoVaTen"],
                  "chuyenKhoa": e["chuyenKhoa"]["tenChuyenKhoa"],
                  "lichLamViec": e["lichLamViec"],
                  "gioiThieu": e["gioiThieu"],
                  "danhGia": e["danhGiaTrungBinh"],
                },
              )
              .toList();
    } else {
      throw Exception("Lỗi tải dữ liệu: ${resp.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn bác sĩ", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF0165FC),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // Ô tìm kiếm bác sĩ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Tìm nhanh tên bác sĩ",
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),

          // Bộ lọc chuyên khoa & giới tính
          Padding(
            padding: const EdgeInsets.only(right: 26, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  onSelected:
                      (value) => setState(() => _selectedSpecialty = value),
                  itemBuilder: (context) {
                    if (loadingCK) {
                      return [
                        const PopupMenuItem(
                          value: "Đang tải...",
                          child: Text("Đang tải..."),
                        ),
                      ];
                    }
                    return chuyenKhoaList.map((ck) {
                      return PopupMenuItem(value: ck, child: Text(ck));
                    }).toList();
                  },

                  child: Container(
                    height: 35,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xFF0165FC),
                    ),
                    child: Center(
                      child: Text(
                        "$_selectedSpecialty ▼",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  onSelected:
                      (value) => setState(() => _selectedGender = value),
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(value: "Nam", child: Text("Nam")),
                        const PopupMenuItem(value: "Nữ", child: Text("Nữ")),
                      ],
                  child: Container(
                    height: 35,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xFF0165FC),
                    ),
                    child: Center(
                      child: Text(
                        "$_selectedGender ▼",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 26, top: 20),
            child: Text(
              "Danh sách bác sĩ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Danh sách bác sĩ
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: danhSachBacSi.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final bacSi = danhSachBacSi[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 100,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/bs1.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bacSi["hoVaTen"],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    bacSi["chuyenKhoa"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Nút chọn bác sĩ
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DatLichBacSi(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0165FC),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              "Chọn bác sĩ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
