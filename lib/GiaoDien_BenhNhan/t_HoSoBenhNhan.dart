import 'package:flutter/material.dart';
import 't_TaoMoiHoSoBenhNhan.dart';

class HoSoBenhNhanScreen extends StatelessWidget {
  const HoSoBenhNhanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> danhSachHoSo = [
      {"name": "Nguyễn Minh Trí", "dob": "12/09/2004", "gender": "Nam"},
      {"name": "Lê Thanh Tùng", "dob": "05/04/1998", "gender": "Nam"},
      {"name": "Trần Thanh Mai", "dob": "23/07/1995", "gender": "Nữ"},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0165FC),
        title: const Text("Hồ sơ bệnh nhân", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Phần thông báo nếu chưa có hồ sơ
          if (danhSachHoSo.isEmpty)
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
                  Expanded(
                    child: Text(
                      "Bạn chưa có hồ sơ bệnh nhân. Vui lòng tạo mới hồ sơ để đặt khám.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Danh sách hồ sơ bệnh nhân
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
                      profile["gender"] == "Nam"
                          ? Icons.person
                          : Icons.person_outline,
                      color: Colors.blueAccent,
                      size: 36,
                    ),
                    title: Text(
                      profile["name"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Ngày sinh: ${profile["dob"]}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.blueAccent),
                      onPressed: () {
                        // Sửa hồ sơ
                      },
                    ),
                    onTap: () {
                      // Xem thông tin chi tiết hồ sơ
                    },
                  ),
                );
              },
            ),
          ),

          // Nút tạo hồ sơ mới
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
                      builder: (context) => const TaoHoSoBenhNhanScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add_alt, color: Colors.white),
                label: const Text(
                  "Tạo hồ sơ mới",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
