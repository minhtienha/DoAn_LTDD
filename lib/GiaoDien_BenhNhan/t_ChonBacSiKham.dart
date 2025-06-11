import 'package:doan_nhom06/GiaoDien_BenhNhan/t_DatLichVoiBacSi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class ChonBacSiScreen extends StatefulWidget {
  final Map<String, dynamic> hoSo;
  final int userId;
  final List<Map<String, dynamic>> selectedBookings; // Thêm dòng này
  const ChonBacSiScreen({
    super.key,
    required this.hoSo,
    required this.userId,
    required this.selectedBookings,
  });

  @override
  State<ChonBacSiScreen> createState() => _ChonBacSiScreenState();
}

String _combineSchedule(String days, String times) {
  final dList = days.split(';').map((e) => e.trim()).toList();
  final tList = times.split(';').map((e) => e.trim()).toList();
  final out = <String>[];
  for (int i = 0; i < dList.length && i < tList.length; i++) {
    out.add("${dList[i]}: ${tList[i]}");
  }
  return out.join(";");
}

class _ChonBacSiScreenState extends State<ChonBacSiScreen> {
  String _selectedSpecialty = "Chuyên khoa";
  String _selectedGender = "Tất cả";

  // Nút bộ lọc
  Widget _buildFilterButton(String label) {
    return Container(
      height: 35,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xFF0165FC),
      ),
      alignment: Alignment.center,
      child: Text(
        "$label ▼",
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  List<Map<String, dynamic>> chuyenKhoaList = [];
  List<Map<String, dynamic>> danhSachBacSi = [];
  bool loadingCK = true;
  List<String> gioiTinhList = ["Nam", "Nữ"];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredBacSi = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterBacSi);
    _loadChuyenKhoa();
    _loadBacSi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadChuyenKhoa() async {
    setState(() => loadingCK = true);
    final resp = await http.get(Uri.parse("${getBaseUrl()}api/ChuyenKhoa"));
    if (resp.statusCode == 200) {
      final js = jsonDecode(resp.body) as List;

      chuyenKhoaList =
          js
              .whereType<Map<String, dynamic>>()
              .where((m) => (m['daXoa'] == false || m['daXoa'] == null))
              .where(
                (m) => m.containsKey("tenChuyenKhoa") && m.containsKey("gia"),
              )
              .map(
                (m) => {
                  "maChuyenKhoa": m["maChuyenKhoa"],
                  "tenChuyenKhoa": m["tenChuyenKhoa"] as String,
                  "gia": m["gia"] as num,
                  "daXoa": m['daXoa'] ?? false,
                  "moTa": m['moTa'] ?? '',
                  "ngayTao": m['ngayTao'] ?? '',
                },
              )
              .toList();
    } else {
      throw Exception("Lỗi tải Chuyên khoa: ${resp.statusCode}");
    }
    setState(() => loadingCK = false);
  }

  Future<void> _loadBacSi() async {
    final resp = await http.get(Uri.parse("${getBaseUrl()}api/BacSi"));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as List;
      danhSachBacSi =
          data.where((e) => e['daXoa'] == false || e['daXoa'] == null).map((e) {
            final rawGt = (e['gioiTinh'] as String? ?? '').trim().toLowerCase();
            String normalizedGt;
            if (rawGt == 'nam') {
              normalizedGt = 'Nam';
            } else if (rawGt == 'nữ' || rawGt == 'nu') {
              normalizedGt = 'Nữ';
            } else {
              normalizedGt = '';
            }
            return {
              'id': e['maBacSi'],
              'ten': e['hoVaTen'],
              'chuyenKhoa': e['chuyenKhoa']['tenChuyenKhoa'],
              'gia': e['chuyenKhoa']['gia'],
              'lichLamViec': _combineSchedule(
                e['ngayLamViec'] ?? '',
                e['khungGioLamViec'] ?? '',
              ),
              'gioiThieu': e['gioiThieu'],
              'danhGia': e['danhGiaTrungBinh'],
              'hinhAnh': e['hinhAnh'],
              'gioiTinh': normalizedGt,
            };
          }).toList();
      // Debug: in ra các giá trị giới tính khả dụng
      debugPrint(
        'Available genders: ${danhSachBacSi.map((bs) => bs['gioiTinh']).toSet()}',
      );
      _filterBacSi();
    } else {
      throw Exception("Lỗi tải Bác sĩ: ${resp.statusCode}");
    }
  }

  void _filterBacSi() {
    final keyword = _searchController.text.toLowerCase().trim();
    setState(() {
      filteredBacSi =
          danhSachBacSi.where((bs) {
            final matchName =
                keyword.isEmpty || bs['ten'].toLowerCase().contains(keyword);
            final matchCK =
                _selectedSpecialty == 'Chuyên khoa' ||
                bs['chuyenKhoa'] == _selectedSpecialty;
            final matchGender =
                _selectedGender == 'Tất cả' ||
                bs['gioiTinh'] == _selectedGender;
            return matchName && matchCK && matchGender;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn bác sĩ', style: TextStyle(color: Colors.white)),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Tìm nhanh tên bác sĩ',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 26, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() => _selectedSpecialty = value);
                    _filterBacSi();
                  },
                  itemBuilder: (ctx) {
                    if (loadingCK) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'Chuyên khoa',
                          child: Text('Chuyên khoa'),
                        ),
                      ];
                    }
                    final items = <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Chuyên khoa',
                        child: Text('Chuyên khoa'),
                      ),
                    ];
                    items.addAll(
                      chuyenKhoaList.map((ck) {
                        return PopupMenuItem<String>(
                          value: ck['tenChuyenKhoa'],
                          child: Text(ck['tenChuyenKhoa']),
                        );
                      }),
                    );
                    return items;
                  },
                  child: _buildFilterButton(_selectedSpecialty),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() => _selectedGender = value);
                    _filterBacSi();
                  },
                  itemBuilder: (_) {
                    final items = <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Tất cả',
                        child: Text('Tất cả'),
                      ),
                    ];
                    items.addAll(
                      gioiTinhList.map((g) {
                        return PopupMenuItem<String>(value: g, child: Text(g));
                      }),
                    );
                    return items;
                  },
                  child: _buildFilterButton(_selectedGender),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 26, top: 20),
            child: Text(
              'Danh sách bác sĩ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredBacSi.length,
              itemBuilder: (context, index) {
                final bacSi = filteredBacSi[index];
                // Lấy chuỗi base64
                final String? base64String = bacSi['hinhAnh'];
                Uint8List? imageBytes;
                if (base64String != null && base64String.isNotEmpty) {
                  imageBytes = base64Decode(base64String);
                }

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
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image:
                                      imageBytes != null
                                          ? MemoryImage(imageBytes)
                                          : AssetImage(
                                                'assets/images/default.png',
                                              )
                                              as ImageProvider,
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
                                    bacSi['ten'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    bacSi['chuyenKhoa'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.info_outline,
                                            color: Colors.blueAccent,
                                            size: 18,
                                          ),
                                        ),
                                        const WidgetSpan(
                                          child: SizedBox(width: 6),
                                        ),
                                        TextSpan(
                                          text: bacSi['gioiThieu'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.schedule,
                                            color: Colors.green,
                                            size: 18,
                                          ),
                                        ),
                                        const WidgetSpan(
                                          child: SizedBox(width: 6),
                                        ),
                                        const TextSpan(
                                          text: 'Lịch làm việc:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const TextSpan(text: '\n'),
                                        TextSpan(
                                          text: bacSi['lichLamViec'].replaceAll(
                                            ';',
                                            '\n',
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DatLichBacSi(
                                        hoSo: widget.hoSo,
                                        bacSi: bacSi,
                                        userId: widget.userId,
                                        selectedBookings:
                                            widget.selectedBookings,
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0165FC),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Chọn bác sĩ',
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
