import 'package:doan_nhom06/GiaoDien_BenhNhan/t_DatLichKhamChuyenKhoa.dart';
import 'package:flutter/material.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_ChonBacSiKham.dart';

class ChonHoSoScreen extends StatelessWidget {
  final bool isChuyenKhoa;
  const ChonHoSoScreen({super.key, required this.isChuyenKhoa});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> danhSachHoSo = [
      {"ten": "Nguyễn Minh Trí", "sdt": "0355 876 097"},
      {"ten": "Lê Thanh Tùng", "sdt": "0983 456 789"},
      {"ten": "Trần Thanh Mai", "sdt": "0937 123 456"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn hồ sơ đặt khám"),
        backgroundColor: const Color(0xFF0165FC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: danhSachHoSo.length,
              itemBuilder: (context, index) {
                final hoSo = danhSachHoSo[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                      size: 36,
                    ),
                    title: Text(
                      hoSo["ten"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("SĐT: ${hoSo["sdt"]}"),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        // Điều hướng theo chức năng đang chọn
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    isChuyenKhoa
                                        ? const ChonChuyenKhoaScreen()
                                        : const ChonBacSiScreen(),
                          ),
                        );
                      },
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
