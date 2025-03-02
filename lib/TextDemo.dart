import 'package:flutter/material.dart';
import 'second_page.dart';

class TextDemo extends StatelessWidget {
  const TextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng demo Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TextDemoScreen(),
    );
  }
}

class TextDemoScreen extends StatelessWidget {
  const TextDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sử dụng Text và Imgae",
          style: TextStyle(
            color: Color.fromARGB(255, 201, 229, 16),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.blue[900],
        leading: IconButton(icon: const Icon(Icons.home), onPressed: () {}),
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
                child: Text(
                  "LẬP TRÌNH DI ĐỘNG KHOÁ 13!",
                  style: TextStyle(
                    color: Color.fromARGB(255, 235, 19, 19),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Image.asset(
                "assets/images/my-avatar.jpg",
                width: 200,
                height: 200,
                fit: BoxFit.scaleDown,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, left: 8),
              child: Text(
                "Chúc các bạn đạt kết quả tốt",
                style: TextStyle(
                  color: Color.fromARGB(255, 169, 13, 248),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Vũ Văn Vinh",
                style: TextStyle(
                  color: Color.fromARGB(255, 54, 63, 244),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Số tiết: 75 tiết",
                style: TextStyle(
                  color: Color.fromARGB(255, 54, 63, 244),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.all(
                    20,
                  ), // 👌 Tăng padding để làm tròn hơn
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecondPage(),
                    ), // Sử dụng const nếu SecondPage là const
                  );
                },
                child: Text("22"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
