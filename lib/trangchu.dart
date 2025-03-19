import 'package:doan_nhom06/DatLichKhamBenh.dart';
import 'package:doan_nhom06/HoSoBenhNhan.dart';
import 'package:doan_nhom06/PhieuDatLich.dart';
import 'package:doan_nhom06/trangcauhoithuonggap.dart';
import 'package:doan_nhom06/DatTheoBacSi.dart';
import 'package:flutter/material.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTrangChuBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffeaecf0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: "Tìm kiếm",
              hintStyle: const TextStyle(
                color: Color.fromARGB(255, 118, 117, 117),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                decorationThickness: 6,
              ),
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 12,
            runSpacing: 12,
            children: [
              buildItem(
                "Đặt lịch khám bệnh",
                "assets/images/icondatlich.jpg",
                DatLichKhamBenh(),
              ),
              buildItem(
                "Đặt lịch theo bác sĩ",
                "assets/images/bacsi.png",
                DatTheoBacSi(),
              ),
              buildItem(
                "Hồ sơ bệnh nhân",
                "assets/images/hosobenh.png",
                PatientProfileScreen(),
              ),
              buildItem(
                "Phiếu đặt lịch",
                "assets/images/hoadon.png",
                MyBookingsScreen(),
              ), // Item mới
            ],
          ),
        ),
      ],
    );
  }

  Widget buildItem(String title, String imagePath, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => page));
      },
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 120,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.lightBlue[50],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      _buildTrangChuBody(),
      const Text('COURSE PAGE', style: optionStyle),
      const Text('CONTACT GFG', style: optionStyle),
      const Text('CONTACT GFG', style: optionStyle),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0165FC),
        //automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.white, // Đổi màu nút menu
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Scaffold.of(
                  context,
                ).openDrawer(); // Mở Drawer khi nhấp vào hình ảnh
              },
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
            const SizedBox(width: 10),
            const Text(
              "Chào Minh Trí \n đến với Hospital 3T",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor:
            Colors.white, // Màu nền của phần thân Drawer là màu trắng
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF0165FC), // Màu nền của header giống AppBar
              ),
              accountName: const Text("Nguyễn Minh Trí"),
              accountEmail: const Text("minhtri01292004@gmail.com"),
              currentAccountPictureSize: const Size.square(50),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.asset(
                    "assets/images/bong.png",
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // ListTile(
            //   leading: const Icon(Icons.bar_chart),
            //   title: const Text("Thống kê"),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text("Tổng đài CSKH 0355876097"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Các câu hỏi thường gặp"),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => const CauHoi()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Đăng xuất"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () => CustomerSupportSheet.show(context),
        backgroundColor: const Color(0xFF0165FC),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      bottomNavigationBar: MyButtonNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class MyButtonNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MyButtonNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Course',
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Contact',
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_call),
          label: 'Contact',
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: const Color.fromARGB(255, 8, 74, 197),
      unselectedItemColor: const Color.fromARGB(255, 183, 188, 193),
      onTap: onItemTapped,
    );
  }
}

class CustomerSupportSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Chăm sóc khách hàng",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildOption(
                icon: Icons.phone,
                title: "ĐẶT KHÁM",
                subtitle: "0355876097",
                onTap: () {
                  // Gọi điện
                },
              ),
              _buildOption(
                icon: Icons.message,
                title: "MESSENGER",
                onTap: () {
                  // Mở Messenger
                },
              ),
              _buildOption(
                icon: Icons.chat,
                title: "ZALO",
                onTap: () {
                  // Mở Zalo
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Đóng", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue, size: 30),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle:
          subtitle != null
              ? Text(subtitle, style: const TextStyle(color: Colors.blue))
              : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
