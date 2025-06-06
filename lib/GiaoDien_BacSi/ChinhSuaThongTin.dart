import 'package:flutter/material.dart';

class ChinhSuaHoSoBacSi extends StatefulWidget {
  const ChinhSuaHoSoBacSi({super.key});

  @override
  _ChinhSuaHoSoBacSiState createState() => _ChinhSuaHoSoBacSiState();
}

class _ChinhSuaHoSoBacSiState extends State<ChinhSuaHoSoBacSi> {
  final TextEditingController nameController = TextEditingController(
    text: "Bác sĩ Nguyễn Văn A",
  );
  final TextEditingController departmentController = TextEditingController(
    text: "Khoa Nội Tổng Hợp",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "0123 456 789",
  );
  final TextEditingController emailController = TextEditingController(
    text: "bacsia@example.com",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chỉnh Sửa Hồ Sơ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField("Họ tên", nameController),
            buildTextField("Chuyên khoa", departmentController),
            buildTextField("Số điện thoại", phoneController),
            buildTextField("Email", emailController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Lưu thông tin",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
