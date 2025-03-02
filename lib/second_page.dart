import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trang 2"), backgroundColor: Colors.red),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Quay lại màn hình trước (HomePage)
                Navigator.pop(context);
              },
              child: Text("Quay lại trang chủ"),
            ),
          ],
        ),
      ),
    );
  }
}
