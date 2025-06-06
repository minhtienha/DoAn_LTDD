import 'package:doan_nhom06/GiaoDien_BenhNhan/DangNhap.dart';
import 'package:flutter/material.dart';

class DangKy extends StatelessWidget {
  const DangKy({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0165FC),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Đặt lịch khám bệnh",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Banner hình ảnh
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    "assets/images/banner.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Họ tên", style: _labelStyle),
                      const SizedBox(height: 8),
                      _buildTextField("Nhập họ tên"),
                      const SizedBox(height: 16),
                      const Text("Email", style: _labelStyle),
                      const SizedBox(height: 8),
                      _buildTextField("Nhập email"),
                      const SizedBox(height: 16),
                      const Text("Mật khẩu", style: _labelStyle),
                      const SizedBox(height: 8),
                      _buildTextField("Nhập mật khẩu", obscureText: true),
                      const SizedBox(height: 16),
                      const Text("Xác nhận mật khẩu", style: _labelStyle),
                      const SizedBox(height: 8),
                      _buildTextField("Nhập lại mật khẩu", obscureText: true),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Logic đăng ký
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0165FC),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Đăng ký",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DangNhap(),
                              ),
                            );
                          },
                          child: const Text(
                            "Đã có tài khoản? Đăng nhập ngay",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Định dạng tiêu đề
const TextStyle _labelStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black87,
);

// Widget TextField chung
Widget _buildTextField(String hintText, {bool obscureText = false}) {
  return TextField(
    obscureText: obscureText,
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xffeaecf0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color.fromARGB(255, 118, 117, 117),
        fontSize: 16,
      ),
    ),
  );
}
