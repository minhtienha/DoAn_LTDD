import 'package:flutter/material.dart';

class PhanCongChuyenKhoa extends StatelessWidget {
  const PhanCongChuyenKhoa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phân Công Chuyên Khoa"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Chọn bác sĩ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "bs1",
                  child: Text("Bác sĩ Nguyễn Văn A"),
                ),
                DropdownMenuItem(
                  value: "bs2",
                  child: Text("Bác sĩ Trần Thị B"),
                ),
                DropdownMenuItem(value: "bs3", child: Text("Bác sĩ Lê Văn C")),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Chọn chuyên khoa",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "khoa1",
                  child: Text("Khoa Nội Tổng Quát"),
                ),
                DropdownMenuItem(
                  value: "khoa2",
                  child: Text("Khoa Ngoại Thần Kinh"),
                ),
                DropdownMenuItem(value: "khoa3", child: Text("Khoa Tim Mạch")),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Xử lý lưu phân công
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Lưu phân công",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
