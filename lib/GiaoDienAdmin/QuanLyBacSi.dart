import 'package:doan_nhom06/GiaoDienAdmin/SuaThongTinBacSi.dart';
import 'package:doan_nhom06/GiaoDienAdmin/ThemBacSi.dart';
import 'package:flutter/material.dart';

class QuanLyTaiKhoanBacSi extends StatelessWidget {
  const QuanLyTaiKhoanBacSi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản Lý Tài Khoản Bác Sĩ"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemBacSi()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Tìm kiếm bác sĩ",
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
                      title: Text("Bác sĩ ${index + 1}"),
                      subtitle: Text("Email: bs${index + 1}@example.com"),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == "edit") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SuaThongTinBacSi(),
                              ),
                            );
                          }
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
