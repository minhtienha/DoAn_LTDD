import 'dart:convert';
import 'package:doan_nhom06/GiaoDienAdmin/TrangChuAdmin.dart';
import 'package:doan_nhom06/GiaoDien_BacSi/TrangChu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doan_nhom06/GiaoDien_BenhNhan/DangKy.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/trangChu.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class DangNhap extends StatefulWidget {
  const DangNhap({super.key});

  @override
  _DangNhapState createState() => _DangNhapState();
}

class _DangNhapState extends State<DangNhap> {
  // Controllers để lấy giá trị từ TextField
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Biến để thể hiện trạng thái loading khi gọi API
  bool _isLoading = false;

  // Biến lưu lỗi (nếu có)
  String? _errorMessage;

  // Hàm gọi API và xử lý đăng nhập
  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Vui lòng nhập đầy đủ email và mật khẩu.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Không dùng try-catch nữa
    final uri = Uri.parse("${getBaseUrl()}api/NguoiDung");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);

      final matchedUser = users.firstWhere(
        (u) =>
            u['email'].toString().toLowerCase() == email.toLowerCase() &&
            u['matKhau'].toString() == password,
        orElse: () => null,
      );

      if (matchedUser != null) {
        final int id = matchedUser['maNguoiDung'] as int;
        final String role = matchedUser['vaiTro'] ?? '';

        if (role == 'bệnh nhân') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrangChu(userId: id)),
          ).then((_) {
            _emailController.clear();
            _passwordController.clear();
            setState(() {
              _errorMessage = null;
            });
          });
        } else if (role == 'bác sĩ') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrangChuBacSi(userId: id)),
          ).then((_) {
            _emailController.clear();
            _passwordController.clear();
            setState(() {
              _errorMessage = null;
            });
          });
        } else if (role == 'quản trị viên') {
          Navigator.of(context)
              .push(
                MaterialPageRoute(builder: (_) => TrangChuAdmin(userId: id)),
              )
              .then((_) {
                _emailController.clear();
                _passwordController.clear();
                setState(() {
                  _errorMessage = null;
                });
              });
        }
      } else {
        setState(() {
          _errorMessage = "Email hoặc mật khẩu không đúng.";
        });
      }
    } else {
      setState(() {
        _errorMessage =
            "Lỗi server: ${response.statusCode}. Vui lòng thử lại sau.";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0165FC),
          title: const Text(
            "Đặt lịch khám bệnh",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Container(),
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

                // Email
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffeaecf0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Nhập email",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 118, 117, 117),
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Mật khẩu
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mật khẩu",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffeaecf0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Nhập mật khẩu",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 118, 117, 117),
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Hiển thị lỗi nếu có
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                ],

                // Nút Đăng nhập
                Center(
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            onPressed: _login,
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
                              "Đăng nhập",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                ),

                const SizedBox(height: 16),

                // Link chuyển sang trang Đăng ký
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DangKy()),
                      );
                      _emailController.clear();
                      _passwordController.clear();
                      setState(() {
                        _errorMessage = null;
                      });
                    },
                    child: const Text(
                      "Chưa có tài khoản? Đăng ký ngay",
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
        ),
      ),
    );
  }
}
