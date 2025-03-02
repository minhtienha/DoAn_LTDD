import 'package:flutter/material.dart';

class Bai1Chuong3 extends StatelessWidget {
  const Bai1Chuong3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bài tập 1 Chương 3",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ), // Áp dụng theme xanh lá cho toàn bộ app
      home: const Bai1Chuong3Screen(), // Chạy màn hình chính
    );
  }
}

// Lớp giao diện chính
class Bai1Chuong3Screen extends StatelessWidget {
  const Bai1Chuong3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thông tin sinh viên",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(icon: Icon(Icons.home), onPressed: () {}),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ClipOval(
                child: Image.asset(
                  "assets/images/my-avatar.jpg",
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 8),
            child: Text(
              "Họ và  tên: Hà Minh Tiến",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 8),
            child: Text(
              "MSSV: 2001224407",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 8),
            child: Text(
              "Lớp: 13DHTH05",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 8),
            child: Text(
              "Ngành: Công nghệ thông tin",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 8),
            child: Text(
              "Trường: Đại học Công Thương Thành phố Hồ Chí Minh",
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
