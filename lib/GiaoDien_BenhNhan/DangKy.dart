import 'package:doan_nhom06/DangNhap.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class DangKy extends StatefulWidget {
  const DangKy({super.key});

  @override
  State<DangKy> createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = "Vui lòng nhập đầy đủ thông tin.";
      });
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = "Mật khẩu xác nhận không khớp.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Kiểm tra email trùng
    final checkUrl = Uri.parse("${getBaseUrl()}api/NguoiDung");
    final checkResp = await http.get(checkUrl);
    if (checkResp.statusCode == 200) {
      final List<dynamic> users = jsonDecode(checkResp.body);
      final exists = users.any(
        (u) => u['email'].toString().toLowerCase() == email.toLowerCase(),
      );
      if (exists) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Email đã tồn tại. Vui lòng dùng email khác.";
        });
        return;
      }
    }

    final url = Uri.parse("${getBaseUrl()}api/NguoiDung");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "hoVaTen": name,
        "email": email,
        "matKhau": password,
        "vaiTro": "bệnh nhân",
        "ngaytao": DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _errorMessage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đăng ký thành công! Vui lòng đăng nhập."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DangNhap()),
      );
    } else {
      setState(() {
        _errorMessage = "Đăng ký thất bại: ${response.body}";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

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
                      _buildTextField(
                        "Nhập họ tên",
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      const Text("Email", style: _labelStyle),
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        "Nhập email",
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
                      const Text("Mật khẩu", style: _labelStyle),
                      const SizedBox(height: 8),
                      _buildTextField(
                        "Nhập mật khẩu",
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 16),
                      const Text("Xác nhận mật khẩu", style: _labelStyle),
                      const SizedBox(height: 8),
                      _buildTextField(
                        "Nhập lại mật khẩu",
                        obscureText: true,
                        controller: _confirmPasswordController,
                      ),
                      const SizedBox(height: 24),

                      Center(
                        child:
                            _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                  onPressed: _register,
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
Widget _buildTextField(
  String hintText, {
  bool obscureText = false,
  TextEditingController? controller,
}) {
  return TextField(
    controller: controller,
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
