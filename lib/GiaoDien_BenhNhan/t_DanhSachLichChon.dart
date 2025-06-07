import 'package:doan_nhom06/GiaoDien_BenhNhan/t_ThanhToan.dart';
import 'package:flutter/material.dart';
import 't_ThemChuyenKhoa.dart';

class DanhSachLichChuaThanhToanScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedBookings;

  const DanhSachLichChuaThanhToanScreen({
    super.key,
    required this.selectedBookings,
  });

  @override
  State<DanhSachLichChuaThanhToanScreen> createState() =>
      _DanhSachLichChuaThanhToanScreenState();
}

class _DanhSachLichChuaThanhToanScreenState
    extends State<DanhSachLichChuaThanhToanScreen> {
  void _themLich() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => const ThemChuyenKhoaScreen(ngayChon: "12/06/2025"),
      ),
    );
  }

  void _thanhToan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ThanhToanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thông tin đặt khám",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0165FC),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                widget.selectedBookings.isEmpty
                    ? const Center(
                      child: Text(
                        "Danh sách lịch đặt trống!",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.selectedBookings.length,
                      itemBuilder: (context, index) {
                        final lich = widget.selectedBookings[index];
                        Color sessionColor =
                            lich["khungGio"]!.contains("AM")
                                ? Colors.green
                                : Colors.orange;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lich["bacSi"]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Chuyên khoa: ${lich["chuyenKhoa"]}"),
                                Text("Ngày khám: ${lich["ngayKham"]}"),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: sessionColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Giờ khám: ${lich["khungGio"]}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _themLich,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Thêm chuyên khoa",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _thanhToan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  icon: const Icon(Icons.payment, color: Colors.white),
                  label: const Text(
                    "Thanh toán",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
