import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class QuanLyDanhMucChuyenKhoa extends StatefulWidget {
  const QuanLyDanhMucChuyenKhoa({super.key});

  @override
  State<QuanLyDanhMucChuyenKhoa> createState() =>
      _QuanLyDanhMucChuyenKhoaState();
}

class _QuanLyDanhMucChuyenKhoaState extends State<QuanLyDanhMucChuyenKhoa> {
  List<dynamic> chuyenKhoaList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchChuyenKhoa();
  }

  Future<void> fetchChuyenKhoa() async {
    setState(() => loading = true);
    final resp = await http.get(Uri.parse('${getBaseUrl()}api/ChuyenKhoa'));
    if (resp.statusCode == 200) {
      chuyenKhoaList = jsonDecode(resp.body) as List;
    }
    setState(() => loading = false);
  }

  void showDialogChuyenKhoa({Map<String, dynamic>? data}) {
    final formKey = GlobalKey<FormState>();
    final tenController = TextEditingController(
      text: data?['tenChuyenKhoa'] ?? "",
    );
    final moTaController = TextEditingController(text: data?['moTa'] ?? "");
    final giaController = TextEditingController(
      text: data?['gia']?.toString() ?? "",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            data == null ? "Thêm Chuyên Khoa" : "Chỉnh sửa Chuyên Khoa",
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: tenController,
                    decoration: InputDecoration(labelText: "Tên chuyên khoa"),
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
                                ? "Nhập tên chuyên khoa"
                                : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: moTaController,
                    decoration: InputDecoration(labelText: "Mô tả"),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: giaController,
                    decoration: InputDecoration(labelText: "Giá"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Nhập giá";
                      }
                      if (double.tryParse(value) == null) {
                        return "Giá không hợp lệ";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final body = {
                  "tenChuyenKhoa": tenController.text,
                  "moTa": moTaController.text,
                  "gia": double.tryParse(giaController.text) ?? 0,
                  "ngayTao": DateTime.now().toIso8601String(),
                };
                if (data == null) {
                  // Thêm mới
                  final resp = await http.post(
                    Uri.parse('${getBaseUrl()}api/ChuyenKhoa'),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode(body),
                  );
                  if (resp.statusCode == 201 || resp.statusCode == 200) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Thêm thành công")));
                    fetchChuyenKhoa();
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Thêm thất bại")));
                  }
                } else {
                  // Sửa
                  final resp = await http.put(
                    Uri.parse(
                      'http://localhost:5001/api/ChuyenKhoa/${data['maChuyenKhoa']}',
                    ),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode({
                      ...body,
                      "maChuyenKhoa": data['maChuyenKhoa'],
                      "ngayTao": data['ngayTao'],
                    }),
                  );
                  if (resp.statusCode == 200 || resp.statusCode == 204) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Cập nhật thành công")),
                    );
                    fetchChuyenKhoa();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Cập nhật thất bại")),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: Text(data == null ? "Thêm" : "Lưu"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteChuyenKhoa(int maChuyenKhoa) async {
    final resp = await http.delete(
      Uri.parse('${getBaseUrl()}api/ChuyenKhoa/$maChuyenKhoa'),
    );
    if (resp.statusCode == 200 || resp.statusCode == 204) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Xóa thành công")));
      fetchChuyenKhoa();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Xóa thất bại")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản Lý Danh Mục Chuyên Khoa"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add, color: Colors.white),
              label: Text("Thêm mới", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              onPressed: () => showDialogChuyenKhoa(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            loading
                ? Center(child: CircularProgressIndicator())
                : chuyenKhoaList.isEmpty
                ? Center(child: Text("Không có chuyên khoa nào"))
                : ListView.builder(
                  itemCount: chuyenKhoaList.length,
                  itemBuilder: (context, index) {
                    final ck = chuyenKhoaList[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Icon(
                            Icons.local_hospital,
                            color: Colors.blue[700],
                          ),
                        ),
                        title: Text(
                          ck['tenChuyenKhoa'] ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (ck['moTa'] != null &&
                                ck['moTa'].toString().isNotEmpty)
                              Text("Mô tả: ${ck['moTa']}"),
                            Text("Giá: ${ck['gia'] ?? 0} VNĐ"),
                            if (ck['ngayTao'] != null)
                              Text(
                                "Ngày tạo: ${ck['ngayTao'].toString().substring(0, 10)}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "edit") {
                              showDialogChuyenKhoa(data: ck);
                            } else if (value == "delete") {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text("Xác nhận xóa"),
                                      content: Text(
                                        "Bạn có chắc muốn xóa chuyên khoa này?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: Text("Hủy"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            deleteChuyenKhoa(
                                              ck['maChuyenKhoa'],
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: Text("Xóa"),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          },
                          itemBuilder:
                              (BuildContext context) => [
                                const PopupMenuItem(
                                  value: "edit",
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text("Chỉnh sửa"),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: "delete",
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text("Xóa"),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
