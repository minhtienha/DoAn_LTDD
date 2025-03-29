import 'package:flutter/material.dart';

class QuanLyDanhMucChuyenKhoa extends StatelessWidget {
  const QuanLyDanhMucChuyenKhoa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản Lý Danh Mục Chuyên Khoa"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _hienThiHopThoaiThemChuyenKhoa(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Thêm Chuyên Khoa",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  List<String> chuyenKhoa = [
                    "Khoa Nội Tổng Quát",
                    "Khoa Ngoại Thần Kinh",
                    "Khoa Tim Mạch",
                  ];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(chuyenKhoa[index]),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          // Xử lý chỉnh sửa/xóa chuyên khoa
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

  void _hienThiHopThoaiThemChuyenKhoa(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm Chuyên Khoa"),
          content: TextField(
            decoration: const InputDecoration(labelText: "Tên chuyên khoa"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                // Xử lý thêm chuyên khoa
                Navigator.pop(context);
              },
              child: const Text("Thêm"),
            ),
          ],
        );
      },
    );
  }
}
