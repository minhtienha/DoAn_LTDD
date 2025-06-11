import 'dart:convert';
import 'package:doan_nhom06/GiaoDienAdmin/TrangChuAdmin.dart';
import 'package:doan_nhom06/GiaoDien_BacSi/t_TrangChuBacSi.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_TrangChuBenhNhan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doan_nhom06/GiaoDien_BenhNhan/DangKy.dart';
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

class _DangNhapState extends State<DangNhap> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

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
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0165FC), Color(0xFF4A90E2), Color(0xFF7BB3FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Logo và tiêu đề
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.medical_services,
                            size: 50,
                            color: Color(0xFF0165FC),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Đặt lịch khám bệnh",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Chăm sóc sức khỏe của bạn",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Form đăng nhập
                  SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Đăng nhập",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Chào mừng bạn quay trở lại!",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF718096),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Email field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF7FAFC),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF0165FC),
                                        width: 2,
                                      ),
                                    ),
                                    hintText: "Nhập email của bạn",
                                    hintStyle: const TextStyle(
                                      color: Color(0xFFA0AEC0),
                                      fontSize: 14,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF718096),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Password field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Mật khẩu",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF7FAFC),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF0165FC),
                                        width: 2,
                                      ),
                                    ),
                                    hintText: "Nhập mật khẩu",
                                    hintStyle: const TextStyle(
                                      color: Color(0xFFA0AEC0),
                                      fontSize: 14,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF718096),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF718096),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Error message
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFED7D7),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFE53E3E),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Color(0xFFE53E3E),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: Color(0xFFE53E3E),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child:
                                _isLoading
                                    ? Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF0165FC),
                                            Color(0xFF4A90E2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                    )
                                    : ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF0165FC),
                                              Color(0xFF4A90E2),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "Đăng nhập",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                          ),

                          const SizedBox(height: 24),

                          // Register link
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DangKy(),
                                  ),
                                );
                                _emailController.clear();
                                _passwordController.clear();
                                setState(() {
                                  _errorMessage = null;
                                });
                              },
                              child: RichText(
                                text: const TextSpan(
                                  text: "Chưa có tài khoản? ",
                                  style: TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Đăng ký ngay",
                                      style: TextStyle(
                                        color: Color(0xFF0165FC),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
