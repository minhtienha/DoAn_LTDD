import 'package:flutter/material.dart';

class trangdatlichtheobacsi extends StatelessWidget {
  const trangdatlichtheobacsi({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Thông tin Sản phẩm",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Colors.blue[900],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Hình ảnh sản phẩm
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/hinh/iphone-15-plus.png",
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/hinh/ip15den.png",
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/hinh/ip15trang.png",
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Thông tin sản phẩm
              const Text(
                "Mã sản phẩm: SP12345",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tên sản phẩm: IPHONE 15",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "Nhà sản xuất: Công ty APPLE",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "Giá bán: 25,000,000 VNĐ",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "Mô tả sản phẩm: Đây là một smartphone với nhiều tính năng ưu việt, camera chất lượng cao và thiết kế hiện đại.",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              // Nút thêm vào giỏ hàng
              Center(
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      // Hành động khi nhấn nút
                    },
                    child: const Text("Thêm vào giỏ hàng"),
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