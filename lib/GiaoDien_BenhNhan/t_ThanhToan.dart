import 'package:flutter/material.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/trangChu.dart';

class ThanhToanScreen extends StatelessWidget {
  const ThanhToanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0165FC),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Quét mã QR để thanh toán",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Mã QR hiển thị
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/qr_code.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Nút xác nhận thanh toán
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý xác nhận thanh toán
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Thanh toán thành công!")),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TrangChu()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0165FC),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Xác nhận thanh toán",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
