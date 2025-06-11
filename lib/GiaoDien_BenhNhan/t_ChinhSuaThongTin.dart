import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:email_validator/email_validator.dart';

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class ChinhSuaThongTinCaNhan extends StatefulWidget {
  final int userId;
  const ChinhSuaThongTinCaNhan({super.key, required this.userId});

  @override
  State<ChinhSuaThongTinCaNhan> createState() => _ChinhSuaThongTinCaNhanState();
}

class _ChinhSuaThongTinCaNhanState extends State<ChinhSuaThongTinCaNhan>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _hoVaTenController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _matKhauController = TextEditingController();
  final TextEditingController _xacNhanMatKhauController =
      TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  String?
  _originalEmail; // Store original email to skip duplicate check if unchanged

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _fetchUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoVaTenController.dispose();
    _emailController.dispose();
    _matKhauController.dispose();
    _xacNhanMatKhauController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final String url = "${getBaseUrl()}api/NguoiDung/${widget.userId}";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          _hoVaTenController.text =
              jsonData['hoVaTen'] ?? jsonData['ho_va_ten'] ?? '';
          _emailController.text = jsonData['email'] ?? '';
          _originalEmail = jsonData['email'] ?? ''; // Store original email
          // Password is not fetched from API for security
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Lỗi server (${response.statusCode})";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Không thể kết nối: $e";
        _isLoading = false;
      });
    }
  }

  Future<bool> _checkEmailAvailability(String email) async {
    // Skip check if email hasn't changed
    if (email.trim().toLowerCase() == _originalEmail?.trim().toLowerCase())
      return true;

    final String url = "${getBaseUrl()}api/NguoiDung";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        // Check if email exists for another user
        for (var user in users) {
          if (user['maNguoiDung'] != widget.userId &&
              user['email']?.toString().toLowerCase() ==
                  email.trim().toLowerCase()) {
            return false; // Email is taken
          }
        }
        return true; // Email is available
      }
      return false; // Assume email is taken if fetch fails
    } catch (e) {
      print("Error checking email: $e");
      return false; // Assume email is taken on error
    }
  }

  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Check email availability
    final newEmail = _emailController.text.trim();
    if (!await _checkEmailAvailability(newEmail)) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email đã được sử dụng bởi tài khoản khác")),
      );
      return;
    }

    // Prepare payload
    final body = {'hoVaTen': _hoVaTenController.text.trim(), 'email': newEmail};

    // Only include password if it's provided and confirmed
    if (_matKhauController.text.isNotEmpty &&
        _matKhauController.text == _xacNhanMatKhauController.text) {
      body['matKhau'] = _matKhauController.text.trim();
    }

    final String url = "${getBaseUrl()}api/NguoiDung/${widget.userId}";
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      setState(() => _isSaving = false);

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cập nhật thông tin thành công!")),
        );
        Navigator.pop(
          context,
          true,
        ); // Return true to trigger refresh in TrangChu
      } else if (response.statusCode == 409) {
        // Fallback for duplicate email error from PUT request
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email đã được sử dụng bởi tài khoản khác")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cập nhật thất bại (${response.statusCode})")),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi kết nối: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chỉnh sửa thông tin cá nhân",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF0165FC),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFF0165FC)),
              )
              : _errorMessage != null
              ? Center(
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              )
              : FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Thông tin cá nhân",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0165FC),
                              ),
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              controller: _hoVaTenController,
                              label: "Họ và tên",
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Vui lòng nhập họ và tên";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              controller: _emailController,
                              label: "Email",
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Vui lòng nhập email";
                                }
                                if (!EmailValidator.validate(value.trim())) {
                                  return "Email không hợp lệ";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              controller: _matKhauController,
                              label: "Mật khẩu mới (để trống nếu không đổi)",
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    value.length < 6) {
                                  return "Mật khẩu phải có ít nhất 6 ký tự";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              controller: _xacNhanMatKhauController,
                              label: "Xác nhận mật khẩu mới",
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value) {
                                if (_matKhauController.text.isNotEmpty) {
                                  if (value == null || value.isEmpty) {
                                    return "Vui lòng xác nhận mật khẩu";
                                  }
                                  if (value != _matKhauController.text) {
                                    return "Mật khẩu xác nhận không khớp";
                                  }
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSaving ? null : _saveUserData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0165FC),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child:
                                    _isSaving
                                        ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          "Lưu thay đổi",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[100],
        labelStyle: TextStyle(color: Colors.grey[800]),
      ),
      validator: validator,
    );
  }
}
