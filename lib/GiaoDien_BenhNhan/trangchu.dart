// File: lib/GiaoDien_BenhNhan/TrangChu.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Import các màn hình con (giữ y như cấu trúc của bạn)
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_HoSoBenhNhan.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_DatLichKhamChuyenKhoa.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_ChonHoSoKhamBenh.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_LichSuKham.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_ChonBacSiKham.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_DatLichVoiBacSi.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/trangCauHoiThuongGap.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/DangNhap.dart';

class TrangChu extends StatefulWidget {
  final int userId;
  const TrangChu({super.key, required this.userId});

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> with TickerProviderStateMixin {
  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Thêm biến lưu trữ tên người dùng
  String _userName = "";
  String _userEmail = "";
  bool _isLoadingName = true;
  String? _errorLoadingName;

  @override
  void initState() {
    super.initState();

    // Khởi tạo animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Gọi API lấy tên người dùng dựa vào widget.userId
    _fetchUserName();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Hàm gọi API để lấy thông tin người dùng theo ID (chỉ lấy field hoVaTen)
  Future<void> _fetchUserName() async {
    final int id = widget.userId;
    final String url = "http://localhost:5001/api/NguoiDung/$id";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        // API có thể trả về key 'hoVaTen' hoặc 'ho_va_ten'
        String name = "";
        if (jsonData.containsKey('hoVaTen')) {
          name = jsonData['hoVaTen'] as String;
        } else if (jsonData.containsKey('ho_va_ten')) {
          name = jsonData['ho_va_ten'] as String;
        }

        String email = "";
        if (jsonData.containsKey('email')) {
          email = jsonData['email'] as String;
        }
        setState(() {
          _userName = name;
          _userEmail = email;
          _isLoadingName = false;
        });
      } else {
        setState(() {
          _errorLoadingName = "Lỗi server (${response.statusCode})";
          _isLoadingName = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorLoadingName = "Không thể kết nối: $e";
        _isLoadingName = false;
      });
    }
  }

  /// Xây dựng phần body chính (grid dịch vụ, animation)
  Widget _buildTrangChuBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FBFF), Color(0xFFFFFFFF)],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildServiceCard(
                      "Đặt lịch khám bệnh",
                      "assets/images/icondatlich.jpg",
                      ChonHoSoScreen(
                        userId: widget.userId,
                        bookingType: "ChuyenKhoa", // hoặc "BacSi"
                      ),
                      const Color(0xFF4CAF50),
                      Icons.calendar_today,
                      0,
                    ),
                    _buildServiceCard(
                      "Đặt lịch theo bác sĩ",
                      "assets/images/bacsi.png",
                      ChonHoSoScreen(
                        userId: widget.userId,
                        bookingType: "BacSi",
                      ),
                      const Color(0xFF2196F3),
                      Icons.person_add,
                      1,
                    ),
                    _buildServiceCard(
                      "Hồ sơ bệnh nhân",
                      "assets/images/hosobenh.png",
                      HoSoBenhNhanScreen(),
                      const Color(0xFFFF9800),
                      Icons.folder_special,
                      2,
                    ),
                    _buildServiceCard(
                      "Phiếu đặt lịch",
                      "assets/images/hoadon.png",
                      LichSuKhamScreen(),
                      const Color(0xFF9C27B0),
                      Icons.receipt_long,
                      3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Hàm build một card dịch vụ (giữ nguyên y hệt của bạn)
  Widget _buildServiceCard(
    String title,
    String imagePath,
    Widget page,
    Color accentColor,
    IconData icon,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) => page,
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accentColor.withOpacity(0.8), accentColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 35),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 30,
                      height: 3,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // === AppBar: hiển thị avatar và tên người dùng ===
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0165FC),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "assets/images/bong.png",
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Phần hiển thị tên: nếu _isLoadingName = true -> “Đang tải…”
            // Ngược lại: “Chào <_userName>”
            Expanded(
              child:
                  _isLoadingName
                      ? const Text(
                        "Đang tải...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                      : Text(
                        "Chào ${_userName.isNotEmpty ? _userName : 'User'}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),

      // === Drawer: show avatar + tên + email ===
      drawer: _buildModernDrawer(),

      // === Body chính: grid dịch vụ đã định nghĩa ở trên ===
      body: _buildTrangChuBody(),

      // === FloatingActionButton: chat hỗ trợ khách hàng ===
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0165FC), Color(0xFF0056D6)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0165FC).withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => CustomerSupportSheet.show(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        ),
      ),
    );
  }

  /// Drawer bên trái, header + menu item
  Widget _buildModernDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Header Drawer: avatar + tên + email
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0165FC), Color(0xFF0056D6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    // Ảnh đại diện (cố định)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          "assets/images/bong.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Tên & email người dùng
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isLoadingName
                              ? const Text(
                                "Đang tải...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : Text(
                                _userName.isNotEmpty ? _userName : "User",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          const SizedBox(height: 4),
                          _isLoadingName
                              ? const SizedBox()
                              : Text(
                                _userEmail.isNotEmpty ? _userEmail : "",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
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

          // Các mục trong Drawer (giữ nguyên như bạn)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  _buildDrawerItem(
                    icon: Icons.phone_outlined,
                    title: "Tổng đài CSKH",
                    subtitle: "0355876097",
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    title: "Câu hỏi thường gặp",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const CauHoi()),
                      );
                    },
                  ),
                  const Spacer(),
                  _buildDrawerItem(
                    icon: Icons.logout_outlined,
                    title: "Đăng xuất",
                    isLogout: true,
                    onTap: () async {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const DangNhap(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mỗi ô menu trong Drawer
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isLogout
                    ? Colors.red.withOpacity(0.1)
                    : const Color(0xFF0165FC).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isLogout ? Colors.red : const Color(0xFF0165FC),
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.grey[800],
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF0165FC),
                    fontWeight: FontWeight.w600,
                  ),
                )
                : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }
}

/// Bottom sheet “Chăm sóc khách hàng”
class CustomerSupportSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Icon(
                      Icons.support_agent,
                      color: Color(0xFF0165FC),
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Chăm sóc khách hàng",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0165FC),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSupportOption(
                  icon: Icons.phone,
                  title: "ĐẶT KHÁM",
                  subtitle: "0355876097",
                  color: const Color(0xFF4CAF50),
                  onTap: () {},
                ),
                _buildSupportOption(
                  icon: Icons.message,
                  title: "MESSENGER",
                  color: const Color(0xFF1877F2),
                  onTap: () {},
                ),
                _buildSupportOption(
                  icon: Icons.chat,
                  title: "ZALO",
                  color: const Color(0xFF0068FF),
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Đóng",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildSupportOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                )
                : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
        onTap: onTap,
      ),
    );
  }
}
