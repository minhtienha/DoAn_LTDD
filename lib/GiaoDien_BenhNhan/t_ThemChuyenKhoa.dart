import 'package:flutter/material.dart';
import 't_DanhSachLichChon.dart';

class ThemChuyenKhoaScreen extends StatefulWidget {
  final String ngayChon;
  const ThemChuyenKhoaScreen({super.key, required this.ngayChon});

  @override
  State<ThemChuyenKhoaScreen> createState() => _ThemChuyenKhoaScreenState();
}

class _ThemChuyenKhoaScreenState extends State<ThemChuyenKhoaScreen> {
  String? _selectedSpecialty = "Chọn chuyên khoa";
  String? _selectedTime = "Chọn giờ";
  String? _selectedDoctor = "Chọn bác sĩ";

  final List<String> chuyenKhoaList = [
    "Nội khoa",
    "Nhi khoa",
    "Tim mạch",
    "Da liễu",
    "Xương khớp",
  ];
  final List<Map<String, dynamic>> times = [
    {"time": "7:00 AM", "session": "Sáng"},
    {"time": "7:30 AM", "session": "Sáng"},
    {"time": "1:00 PM", "session": "Chiều"},
    {"time": "2:00 PM", "session": "Chiều"},
  ];
  final List<String> doctorList = [
    "BS. Nguyễn Văn A",
    "BS. Trần Văn B",
    "BS. Lê Thị C",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thêm chuyên khoa",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0165FC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ngày khám:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(widget.ngayChon, style: const TextStyle(fontSize: 16)),
            const Divider(height: 30),

            // Chọn chuyên khoa
            const Text(
              "Chọn chuyên khoa:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            PopupMenuButton<String>(
              onSelected: (value) => setState(() => _selectedSpecialty = value),
              itemBuilder:
                  (context) =>
                      chuyenKhoaList
                          .map(
                            (chuyenKhoa) => PopupMenuItem(
                              value: chuyenKhoa,
                              child: Text(chuyenKhoa),
                            ),
                          )
                          .toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedSpecialty!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Chọn giờ khám
            const Text(
              "Chọn giờ khám:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            PopupMenuButton<String>(
              onSelected: (value) => setState(() => _selectedTime = value),
              itemBuilder:
                  (context) =>
                      times.map<PopupMenuEntry<String>>((timeData) {
                        Color sessionColor =
                            timeData["session"] == "Sáng"
                                ? Colors.green
                                : Colors.orange;
                        return PopupMenuItem<String>(
                          value: timeData["time"],
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: sessionColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              timeData["time"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedTime!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Chọn bác sĩ
            const Text(
              "Chọn bác sĩ:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            PopupMenuButton<String>(
              onSelected: (value) => setState(() => _selectedDoctor = value),
              itemBuilder:
                  (context) =>
                      doctorList
                          .map(
                            (doctor) => PopupMenuItem(
                              value: doctor,
                              child: Text(doctor),
                            ),
                          )
                          .toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedDoctor!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const DanhSachLichChuaThanhToanScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0165FC),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Xác nhận đặt lịch",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
