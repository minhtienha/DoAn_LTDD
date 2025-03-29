import 'package:flutter/material.dart';

class QuanLyTaiKhoanBenhNhan extends StatelessWidget {
  const QuanLyTaiKhoanBenhNhan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản Lý Tài Khoản Bệnh Nhân"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Tìm kiếm bệnh nhân",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 40,
                      ),
                      title: Text("Bệnh nhân ${index + 1}"),
                      subtitle: Text("Email: bn${index + 1}@example.com"),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          // Xử lý hành động theo lựa chọn
                        },
                        itemBuilder:
                            (BuildContext context) => [
                              const PopupMenuItem(
                                value: "edit",
                                child: Text("Chỉnh sửa"),
                              ),
                              const PopupMenuItem(
                                value: "delete",
                                child: Text("Xóa"),
                              ),
                            ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
