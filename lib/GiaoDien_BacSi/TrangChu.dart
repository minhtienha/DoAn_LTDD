import 'package:doan_nhom06/GiaoDien_BacSi/LichKhamBenh.dart';
import 'package:doan_nhom06/GiaoDien_BacSi/QuanLyGioLam.dart';
import 'package:doan_nhom06/GiaoDien_BacSi/ThongTinBacSi.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/DangKy.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/DangNhap.dart';
import 'package:flutter/material.dart';

class TrangChuBacSi extends StatefulWidget {
  const TrangChuBacSi({super.key});

  @override
  State<TrangChuBacSi> createState() => _TrangChuBacSiState();
}

class _TrangChuBacSiState extends State<TrangChuBacSi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/my-avatar.jpg"),
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bác sĩ Nguyễn Văn A",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Khoa Nội Tổng Hợp",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DangKy()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/my-avatar.jpg"),
                    radius: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Bác sĩ Nguyễn Văn A",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Khoa Nội Tổng Hợp",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text("Thông tin cá nhân"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HoSoBacSi()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text("Danh sách lịch khám"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => XacNhanHuyLichKham()),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.people),
            //   title: Text("Danh sách bệnh nhân"),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.folder_open),
            //   title: Text("Hồ sơ bệnh án"),
            //   onTap: () {},
            // ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text("Quản lý giờ làm việc"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuanLyLichLamViec()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Đăng xuất"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DangNhap()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          children: [
            buildItem(
              "Danh sách lịch khám",
              Icons.event_note,
              XacNhanHuyLichKham(),
            ),
            // buildItem("Xác nhận / Hủy lịch", Icons.check_circle, null),
            // buildItem("Danh sách bệnh nhân", Icons.people, null),
            // buildItem("Hồ sơ bệnh án", Icons.folder_open, null),
            buildItem(
              "Quản lý giờ làm việc",
              Icons.schedule,
              QuanLyLichLamViec(),
            ),
            // buildItem("Cập nhật trạng thái", Icons.online_prediction, null),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String title, IconData icon, Widget? page) {
    return InkWell(
      onTap: () {
        if (page != null) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => page));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Trang này chưa có!")));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
