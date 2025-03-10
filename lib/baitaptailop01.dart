import 'package:flutter/material.dart';

class bai01tl extends StatelessWidget {
  const bai01tl({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Ứng dụng demo Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Sử dụng Text và Image",
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
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("LẬP TRÌNH DI ĐỘNG KHÓA 13!",
                          style: TextStyle(
                              color: Color.fromARGB(255, 235, 19, 19),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                    ),
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100), // Bo góc ảnh 20px
                      child: Image.asset(
                        "assets/hinh/bong2.png",
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover, // Hoặc BoxFit.contain tùy vào yêu cầu của bạn
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30, left: 8),
                    child: Text("Họ và tên: Nguyễn Văn A",
                        style: TextStyle(
                            color: Color.fromARGB(255, 169, 13, 248),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("MSSV:2001225555",
                        style: TextStyle(
                            color: Color.fromARGB(255, 199, 22, 22),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),

                        textAlign: TextAlign.left),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Lớp: 13DHTH02",
                        style: TextStyle(
                            color: Color.fromARGB(255, 199, 22, 22),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Khóa : 13 Đại Khóa",
                        style: TextStyle(
                            color: Color.fromARGB(255, 199, 22, 22),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Ngành: Công nghệ thông tin",
                        style: TextStyle(
                            color: Color.fromARGB(255, 199, 22, 22),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Trường: Đại học Công Thương Thành Phố Hồ Chí Minh",
                        style: TextStyle(
                            color: Color.fromARGB(255, 199, 22, 22),
                            fontSize: 20),
                        textAlign: TextAlign.left),
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Trở về"),
                      ),
                    ),
                  ),

                ],
              ),
            )));

  }
}


