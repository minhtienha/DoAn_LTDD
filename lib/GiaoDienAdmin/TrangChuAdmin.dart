import 'package:doan_nhom06/GiaoDienAdmin/PhanCongChuyenKhoa.dart';
import 'package:doan_nhom06/GiaoDienAdmin/QuanLyBacSi.dart';
import 'package:doan_nhom06/GiaoDienAdmin/QuanLyBenhNhan.dart';
import 'package:doan_nhom06/GiaoDienAdmin/QuanLyChuyenKhoa.dart';
import 'package:flutter/material.dart';

class TrangChuAdmin extends StatelessWidget {
  const TrangChuAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trang Chủ Admin",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chào mừng Admin!",
              style: TextStyle(
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
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
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
                    "Phân công chuyên khoa",
                    Icons.assignment,
                    Colors.purple,
                    PhanCongChuyenKhoa(),
                  ),
                  buildDashboardItem(
                    context,
                    "QL danh mục chuyên khoa",
                    Icons.category,
                    Colors.teal,
                    QuanLyDanhMucChuyenKhoa(),
                  ),
                  // buildDashboardItem(
                  //   "QL danh mục loại bệnh",
                  //   Icons.local_hospital,
                  //   Colors.red,
                  // ),
                ],
              ),
            ),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
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
