import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class QuanLyTaiKhoanBenhNhan extends StatefulWidget {
  const QuanLyTaiKhoanBenhNhan({super.key});

  @override
  State<QuanLyTaiKhoanBenhNhan> createState() => _QuanLyTaiKhoanBenhNhanState();
}

class _QuanLyTaiKhoanBenhNhanState extends State<QuanLyTaiKhoanBenhNhan> {
  List<dynamic> benhNhanList = [];
  List<dynamic> filteredList = [];
  bool loading = true;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    fetchBenhNhan();
  }

  Future<void> fetchBenhNhan() async {
    setState(() {
      loading = true;
    });
    final resp = await http.get(Uri.parse('${getBaseUrl()}api/NguoiDung'));
    if (resp.statusCode == 200) {
      final list = jsonDecode(resp.body) as List;
      benhNhanList =
          list
              .where((e) => (e['vaiTro']?.toLowerCase() ?? '') == 'bệnh nhân')
              .toList();
      filteredList = benhNhanList;
    }
    setState(() {
      loading = false;
    });
  }

  void filterSearch(String value) {
    setState(() {
      searchText = value;
      filteredList =
          benhNhanList
              .where(
                (e) =>
                    (e['hoVaTen'] ?? '').toLowerCase().contains(
                      value.toLowerCase(),
                    ) ||
                    (e['email'] ?? '').toLowerCase().contains(
                      value.toLowerCase(),
                    ),
              )
              .toList();
    });
  }

  Future<void> deleteBenhNhan(int maNguoiDung) async {
    final resp = await http.delete(
      Uri.parse('${getBaseUrl()}api/NguoiDung/$maNguoiDung'),
    );
    if (resp.statusCode == 200 || resp.statusCode == 204) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Xóa thành công")));
      fetchBenhNhan();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Xóa thất bại")));
    }
  }

  void showEditDialog(Map<String, dynamic>? data) {
    final formKey = GlobalKey<FormState>();
    final tenController = TextEditingController(text: data?['hoVaTen'] ?? "");
    final emailController = TextEditingController(text: data?['email'] ?? "");
    final matKhauController = TextEditingController(
      text: data?['matKhau'] ?? "",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data == null ? "Thêm bệnh nhân" : "Chỉnh sửa bệnh nhân"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: tenController,
                    decoration: InputDecoration(
                      labelText: "Họ và tên",
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Vui lòng nhập họ và tên";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Vui lòng nhập email";
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return "Email không hợp lệ";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: matKhauController,
                    decoration: InputDecoration(
                      labelText: "Mật khẩu",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng nhập mật khẩu";
                      }
                      if (value.length < 6) {
                        return "Mật khẩu phải từ 6 ký tự";
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
                  "hoVaTen": tenController.text,
                  "email": emailController.text,
                  "matKhau": matKhauController.text,
                  "vaiTro": "bệnh nhân",
                  "ngaytao": DateTime.now().toIso8601String(),
                };
                if (data == null) {
                  // Thêm mới
                  final resp = await http.post(
                    Uri.parse('${getBaseUrl()}api/NguoiDung'),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode(body),
                  );
                  if (resp.statusCode == 201 || resp.statusCode == 200) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Thêm thành công")));
                    fetchBenhNhan();
                    Navigator.pop(context);
                  } else {
                    String errorMsg = "Thêm thất bại";
                    try {
                      final errorData = jsonDecode(resp.body);
                      if (errorData is Map && errorData.containsKey('title')) {
                        errorMsg = errorData['title'];
                      } else if (errorData is Map &&
                          errorData.containsKey('message')) {
                        errorMsg = errorData['message'];
                      } else {
                        errorMsg = resp.body.toString();
                      }
                    } catch (_) {
                      errorMsg = resp.body.toString();
                    }
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(errorMsg)));
                  }
                } else {
                  // Sửa
                  final resp = await http.put(
                    Uri.parse(
                      'http://localhost:5001/api/NguoiDung/${data['maNguoiDung']}',
                    ),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode({
                      ...body,
                      "maNguoiDung": data['maNguoiDung'],
                      "ngayTao": data['ngayTao'],
                      "vaiTro": data['vaiTro'],
                    }),
                  );
                  if (resp.statusCode == 200 || resp.statusCode == 204) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Cập nhật thành công")),
                    );
                    fetchBenhNhan();
                    Navigator.pop(context);
                  } else {
                    String errorMsg = "Cập nhật thất bại";
                    try {
                      final errorData = jsonDecode(resp.body);
                      if (errorData is Map && errorData.containsKey('title')) {
                        errorMsg = errorData['title'];
                      } else if (errorData is Map &&
                          errorData.containsKey('message')) {
                        errorMsg = errorData['message'];
                      } else {
                        errorMsg = resp.body.toString();
                      }
                    } catch (_) {
                      errorMsg = resp.body.toString();
                    }
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(errorMsg)));
                  }
                }
              },
              child: Text(data == null ? "Thêm" : "Lưu"),
            ),
          ],
        );
      },
    );
  }

  Widget buildBenhNhanCard(Map<String, dynamic> bn) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.person, color: Colors.blue[700]),
        ),
        title: Text(
          bn['hoVaTen'] ?? "",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${bn['email'] ?? ""}"),
            if (bn['ngayTao'] != null)
              Text(
                "Ngày tạo: ${bn['ngayTao'].toString().substring(0, 10)}",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "edit") {
              showEditDialog(bn);
            }
            // Không cho phép xóa, nên không xử lý "delete"
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
                // Không thêm PopupMenuItem "delete" nữa
              ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quản Lý Tài Khoản Bệnh Nhân",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue,
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
              onPressed: () => showEditDialog(null),
            ),
          ),
        ],
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
                filled: true,
                fillColor: Colors.blue[50],
              ),
              onChanged: filterSearch,
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  loading
                      ? Center(child: CircularProgressIndicator())
                      : filteredList.isEmpty
                      ? Center(child: Text("Không có bệnh nhân nào"))
                      : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder:
                            (context, index) =>
                                buildBenhNhanCard(filteredList[index]),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
