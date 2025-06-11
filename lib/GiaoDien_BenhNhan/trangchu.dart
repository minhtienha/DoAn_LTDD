import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_HoSoBenhNhan.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_ChonHoSoKhamBenh.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_LichSuKham.dart';
import 'package:doan_nhom06/DangNhap.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class TrangChu extends StatefulWidget {
  final int userId;
  const TrangChu({super.key, required this.userId});

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _userName = "";
  String _userEmail = "";
  bool _isLoadingName = true;
  String? _errorLoadingName;

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

    _fetchUserName();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserName();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserName() async {
    final int id = widget.userId;
    final String url = "${getBaseUrl()}api/NguoiDung/$id";

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
                      HoSoBenhNhanScreen(maNguoiDung: widget.userId),
                      const Color(0xFFFF9800),
                      Icons.folder_special,
                      2,
                    ),
                    _buildServiceCard(
                      "Phiếu đặt lịch",
                      "assets/images/hoadon.png",
                      LichSuKhamScreen(maNguoiDung: widget.userId),
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
                Navigator.of(context)
                    .push(
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
                    )
                    .then((_) {
                      setState(() {});
                    });
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
            const SizedBox(width: 12),

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
          ],
        ),
      ),

      // === Drawer: show avatar + tên + email ===
      drawer: _buildModernDrawer(),

      // === Body chính: grid dịch vụ đã định nghĩa ở trên ===
      body: _buildTrangChuBody(),
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
                  // Đặt lịch khám bệnh
                  _buildDrawerItem(
                    icon: Icons.calendar_today,
                    title: "Đặt lịch khám bệnh",
                    onTap: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder:
                                  (context) => ChonHoSoScreen(
                                    userId: widget.userId,
                                    bookingType: "ChuyenKhoa",
                                  ),
                            ),
                          )
                          .then((_) {
                            setState(() {});
                          });
                    },
                  ),
                  // Đặt lịch theo bác sĩ
                  _buildDrawerItem(
                    icon: Icons.person_add,
                    title: "Đặt lịch theo bác sĩ",
                    onTap: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder:
                                  (context) => ChonHoSoScreen(
                                    userId: widget.userId,
                                    bookingType: "BacSi",
                                  ),
                            ),
                          )
                          .then((_) {
                            setState(() {});
                          });
                    },
                  ),
                  // Hồ sơ bệnh nhân
                  _buildDrawerItem(
                    icon: Icons.folder_special,
                    title: "Hồ sơ bệnh nhân",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => HoSoBenhNhanScreen(
                                maNguoiDung: widget.userId,
                              ),
                        ),
                      );
                    },
                  ),
                  // Phiếu đặt lịch
                  _buildDrawerItem(
                    icon: Icons.receipt_long,
                    title: "Phiếu đặt lịch",
                    onTap: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder:
                                  (context) => LichSuKhamScreen(
                                    maNguoiDung: widget.userId,
                                  ),
                            ),
                          )
                          .then((_) {
                            setState(() {});
                          });
                    },
                  ),
                  // Tổng đài CSKH
                  _buildDrawerItem(
                    icon: Icons.phone_outlined,
                    title: "Tổng đài CSKH",
                    subtitle: "0355876097",
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  // Đăng xuất
                  _buildDrawerItem(
                    icon: Icons.logout_outlined,
                    title: "Đăng xuất",
                    isLogout: true,
                    onTap: () async {
                      Navigator.of(context)
                          .pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const DangNhap(),
                            ),
                          )
                          .then((_) {
                            setState(() {});
                          });
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
