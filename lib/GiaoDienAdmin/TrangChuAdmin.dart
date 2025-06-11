import 'dart:convert';
import 'package:doan_nhom06/GiaoDienAdmin/QuanLyBacSi.dart';
import 'package:doan_nhom06/GiaoDienAdmin/QuanLyBenhNhan.dart';
import 'package:doan_nhom06/GiaoDienAdmin/QuanLyChuyenKhoa.dart';
import 'package:doan_nhom06/GiaoDienAdmin/QuanLyDonXinNghi.dart';
import 'package:doan_nhom06/GiaoDienAdmin/QuanLyLichKham.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class TrangChuAdmin extends StatefulWidget {
  final int userId;
  const TrangChuAdmin({super.key, required this.userId});

  @override
  State<TrangChuAdmin> createState() => _TrangChuAdminState();
}

class _TrangChuAdminState extends State<TrangChuAdmin> {
  int soBacSi = 0;
  int soBenhNhan = 0;
  int soChuyenKhoa = 0;
  bool loading = true;
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    fetchDashboard();
    infoUser();
  }

  Future<void> infoUser() async {
    try {
      final response = await http.get(
        Uri.parse('${getBaseUrl()}api/NguoiDung/${widget.userId}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          user = jsonDecode(response.body);
        });
      }
    } catch (e) {}
  }

  Future<void> fetchDashboard() async {
    try {
      // Lấy số lượng bác sĩ và bệnh nhân từ api/nguoidung
      final respNguoiDung = await http.get(
        Uri.parse('${getBaseUrl()}api/NguoiDung'),
      );
      if (respNguoiDung.statusCode == 200) {
        final list = jsonDecode(respNguoiDung.body) as List;
        // soBacSi = list.where((e) => e['vaiTro'] == 'bác sĩ').length;
        soBenhNhan = list.where((e) => e['vaiTro'] == 'bệnh nhân').length;
      }
      final respBacSi = await http.get(Uri.parse('${getBaseUrl()}api/BacSi'));
      if (respBacSi.statusCode == 200) {
        final list = jsonDecode(respBacSi.body) as List;
        soBacSi =
            list.where((e) {
              final daXoa = e['daXoa'];
              if (daXoa == null) return true;
              if (daXoa is bool) return daXoa == false;
              if (daXoa is int) return daXoa == 0;
              return false;
            }).length;
      }
      // Lấy số lượng chuyên khoa từ api/chuyenkhoa
      final respChuyenKhoa = await http.get(
        Uri.parse('${getBaseUrl()}api/ChuyenKhoa'),
      );
      if (respChuyenKhoa.statusCode == 200) {
        final list = jsonDecode(respChuyenKhoa.body) as List;
        final chuyenKhoaChuaXoa =
            list.where((ck) {
              final daXoa = ck['daXoa'];
              if (daXoa == null) return true;
              if (daXoa is bool) return daXoa == false;
              if (daXoa is int) return daXoa == 0;
              return true;
            }).toList();

        soChuyenKhoa = chuyenKhoaChuaXoa.length;
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Trang Chủ Admin",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF0165FC),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Xác nhận'),
                      content: const Text('Bạn có chắc muốn đăng xuất?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Hủy'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Đăng xuất'),
                        ),
                      ],
                    ),
              );
              if (shouldLogout == true) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body:
          loading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chào mừng ${user?['hoVaTen']}!",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Hệ thống quản lý đặt lịch khám bệnh",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    // Stat cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard("Bác sĩ", soBacSi, Colors.orange),
                        _buildStatCard("Người dùng", soBenhNhan, Colors.green),
                        _buildStatCard(
                          "Chuyên khoa",
                          soChuyenKhoa,
                          Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Dashboard grid
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        buildDashboardItem(
                          context,
                          "QL tài khoản bệnh nhân",
                          Icons.person,
                          Colors.green,
                          QuanLyTaiKhoanBenhNhan(),
                        ),
                        buildDashboardItem(
                          context,
                          "QL tài khoản bác sĩ",
                          Icons.medical_services,
                          Colors.orange,
                          QuanLyTaiKhoanBacSi(),
                        ),
                        buildDashboardItem(
                          context,
                          "QL danh mục chuyên khoa",
                          Icons.category,
                          Colors.teal,
                          QuanLyDanhMucChuyenKhoa(),
                        ),
                        buildDashboardItem(
                          context,
                          "QL thông tin lịch khám",
                          Icons.schedule,
                          Colors.redAccent,
                          QuanLyLichKham(),
                        ),
                        buildDashboardItem(
                          context,
                          "QL đơn xin nghỉ phép",
                          Icons.hourglass_empty,
                          Colors.redAccent,
                          DonXinNghiPhep(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildStatCard(String title, int value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(title, style: TextStyle(fontSize: 15, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget buildDashboardItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
          fetchDashboard();
          infoUser();
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
