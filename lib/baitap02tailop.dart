import 'package:flutter/material.dart';

class ThesisDetailScreen extends StatelessWidget {
  const ThesisDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thông tin Đề tài Đồ án',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Thông tin Đề tài Đồ án",
            style: TextStyle(
                color: Color.fromARGB(255, 201, 229, 16), fontSize: 18),
          ),
          backgroundColor: Colors.blue[900],
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {},
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "assets/hinh/bong3.png", // Đường dẫn đến ảnh
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, left: 8),
                child: Center(
                  child: Text(
                    "Mã đề tài: DT2023",
                    style: TextStyle(
                        color: Color.fromARGB(255, 169, 13, 248),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Tên đề tài: Nghiên cứu ứng dụng Flutter",
                  style: TextStyle(
                      color: Color.fromARGB(255, 199, 22, 22),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Số lượng sinh viên tối đa: 4",
                  style: TextStyle(
                      color: Color.fromARGB(255, 199, 22, 22),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Chuyên ngành: Công nghệ thông tin",
                  style: TextStyle(
                      color: Color.fromARGB(255, 8, 205, 159),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Giảng viên hướng dẫn: ThS. Nguyễn Văn B",
                  style: TextStyle(
                      color: Color.fromARGB(255, 8, 74, 197),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Yêu cầu đề tài: Phát triển ứng dụng di động với Flutter.",
                  style: TextStyle(
                      color: Color.fromARGB(255, 8, 74, 197),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      // Hành động khi nhấn nút
                    },
                    child: const Text("Trở về"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}