import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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

class QuanLyTaiKhoanBacSi extends StatefulWidget {
  const QuanLyTaiKhoanBacSi({super.key});

  @override
  State<QuanLyTaiKhoanBacSi> createState() => _QuanLyTaiKhoanBacSiState();
}

class _QuanLyTaiKhoanBacSiState extends State<QuanLyTaiKhoanBacSi> {
  List<dynamic> bacSiList = [];
  List<dynamic> filteredList = [];
  bool loading = true;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    fetchBacSi();
  }

  Future<void> fetchBacSi() async {
    setState(() => loading = true);
    final resp = await http.get(Uri.parse('${getBaseUrl()}api/BacSi'));
    if (resp.statusCode == 200) {
      bacSiList = jsonDecode(resp.body) as List;
      filteredList = bacSiList;
    }
    setState(() => loading = false);
  }

  void filterSearch(String value) {
    setState(() {
      searchText = value;
      filteredList =
          bacSiList
              .where(
                (e) =>
                    (e['hoVaTen'] ?? '').toLowerCase().contains(
                      value.toLowerCase(),
                    ) ||
                    (e['nguoiDung']?['email'] ?? '').toLowerCase().contains(
                      value.toLowerCase(),
                    ),
              )
              .toList();
    });
  }

  void showAddBacSiDialog() async {
    final formKey = GlobalKey<FormState>();
    final tenController = TextEditingController();
    final emailController = TextEditingController();
    final matKhauController = TextEditingController();
    final gioiThieuController = TextEditingController();
    final ngayLamViecController = TextEditingController();
    final khungGioLamViecController = TextEditingController();
    String? gioiTinh;
    int? maChuyenKhoa;
    Uint8List? imageBytes;
    String? imageBase64;

    // Lấy danh sách chuyên khoa từ API
    List<dynamic> chuyenKhoaList = [];
    final resp = await http.get(Uri.parse('${getBaseUrl()}api/ChuyenKhoa'));
    if (resp.statusCode == 200) {
      chuyenKhoaList = jsonDecode(resp.body) as List;
    }

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageBytes = await File(pickedFile.path).readAsBytes();
        imageBase64 = base64Encode(imageBytes!);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Tạo tài khoản & Thêm Bác Sĩ"),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await pickImage();
                          setState(() {});
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue[50],
                          backgroundImage:
                              imageBytes != null
                                  ? MemoryImage(imageBytes!)
                                  : null,
                          child:
                              imageBytes == null
                                  ? Icon(
                                    Icons.camera_alt,
                                    size: 36,
                                    color: Colors.blue,
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: tenController,
                        decoration: InputDecoration(
                          labelText: "Họ và tên",
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? "Vui lòng nhập họ và tên"
                                    : null,
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
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Mật khẩu",
                          prefixIcon: Icon(Icons.lock),
                        ),
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
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Giới tính",
                          prefixIcon: Icon(Icons.wc),
                        ),
                        value: gioiTinh,
                        items: const [
                          DropdownMenuItem(value: "Nam", child: Text("Nam")),
                          DropdownMenuItem(value: "Nữ", child: Text("Nữ")),
                        ],
                        onChanged: (value) => gioiTinh = value,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Vui lòng chọn giới tính"
                                    : null,
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Chuyên khoa",
                          prefixIcon: Icon(Icons.local_hospital),
                        ),
                        value: maChuyenKhoa,
                        items:
                            chuyenKhoaList
                                .map<DropdownMenuItem<int>>(
                                  (ck) => DropdownMenuItem(
                                    value: ck['maChuyenKhoa'],
                                    child: Text(ck['tenChuyenKhoa']),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) => maChuyenKhoa = value,
                        validator:
                            (value) =>
                                value == null
                                    ? "Vui lòng chọn chuyên khoa"
                                    : null,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: ngayLamViecController,
                        decoration: InputDecoration(
                          labelText: "Ngày làm việc (VD: T2;T4;T6)",
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? "Vui lòng nhập ngày làm việc"
                                    : null,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: khungGioLamViecController,
                        decoration: InputDecoration(
                          labelText:
                              "Khung giờ làm việc (VD: 07:30-11:30;13:00-17:00)",
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? "Vui lòng nhập khung giờ"
                                    : null,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: gioiThieuController,
                        decoration: InputDecoration(
                          labelText: "Giới thiệu",
                          prefixIcon: Icon(Icons.info_outline),
                        ),
                        maxLines: 2,
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
                    // 1. Tạo tài khoản người dùng cho bác sĩ
                    final nguoiDungBody = {
                      "hoVaTen": tenController.text.trim(),
                      "email": emailController.text.trim(),
                      "matKhau": matKhauController.text,
                      "vaiTro": "bác sĩ",
                      "ngayTao": DateTime.now().toIso8601String(),
                    };
                    final respNguoiDung = await http.post(
                      Uri.parse('${getBaseUrl()}api/NguoiDung'),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode(nguoiDungBody),
                    );
                    if (respNguoiDung.statusCode == 201 ||
                        respNguoiDung.statusCode == 200) {
                      final nguoiDung = jsonDecode(respNguoiDung.body);
                      final maNguoiDung = nguoiDung['maNguoiDung'];
                      // 2. Tạo bác sĩ, gán mã người dùng vừa tạo
                      final bacSiBody = {
                        "hoVaTen": tenController.text.trim(),
                        "maNguoiDung": maNguoiDung,
                        "maChuyenKhoa": maChuyenKhoa,
                        "ngayLamViec": ngayLamViecController.text.trim(),
                        "khungGioLamViec":
                            khungGioLamViecController.text.trim(),
                        "gioiThieu": gioiThieuController.text.trim(),
                        "gioiTinh": gioiTinh ?? "",
                        "hinhAnh": imageBase64,
                      };
                      final respBacSi = await http.post(
                        Uri.parse('${getBaseUrl()}api/BacSi'),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode(bacSiBody),
                      );
                      if (respBacSi.statusCode == 201 ||
                          respBacSi.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Thêm bác sĩ thành công")),
                        );
                        fetchBacSi();
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Thêm bác sĩ thất bại (BacSi)"),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Thêm bác sĩ thất bại (Người dùng)"),
                        ),
                      );
                    }
                  },
                  child: Text("Thêm"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEditBacSiDialog(Map<String, dynamic> bs) async {
    final formKey = GlobalKey<FormState>();
    final nguoiDung = bs['nguoiDung'] ?? {};
    final chuyenKhoa = bs['chuyenKhoa'] ?? {};

    final tenController = TextEditingController(text: bs['hoVaTen'] ?? "");
    final emailController = TextEditingController(
      text: nguoiDung['email'] ?? "",
    );
    final hinhAnhController = TextEditingController(
      text: nguoiDung['hinhAnh'] ?? "",
    );
    final gioiThieuController = TextEditingController(
      text: bs['gioiThieu'] ?? "",
    );
    final ngayLamViecController = TextEditingController(
      text: bs['ngayLamViec'] ?? "",
    );
    final khungGioLamViecController = TextEditingController(
      text: bs['khungGioLamViec'] ?? "",
    );
    String? gioiTinh = bs['gioiTinh'];
    int? maChuyenKhoa = chuyenKhoa['maChuyenKhoa'];

    // Lấy danh sách chuyên khoa từ API
    List<dynamic> chuyenKhoaList = [];
    final resp = await http.get(Uri.parse('${getBaseUrl()}api/ChuyenKhoa'));
    if (resp.statusCode == 200) {
      chuyenKhoaList = jsonDecode(resp.body) as List;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chỉnh sửa Bác Sĩ"),
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
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
                                ? "Vui lòng nhập họ và tên"
                                : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    readOnly: true, // Không cho sửa email
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Giới tính",
                      prefixIcon: Icon(Icons.wc),
                    ),
                    value: gioiTinh,
                    items: const [
                      DropdownMenuItem(value: "Nam", child: Text("Nam")),
                      DropdownMenuItem(value: "Nữ", child: Text("Nữ")),
                    ],
                    onChanged: (value) => gioiTinh = value,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Vui lòng chọn giới tính"
                                : null,
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Chuyên khoa",
                      prefixIcon: Icon(Icons.local_hospital),
                    ),
                    value: maChuyenKhoa,
                    items:
                        chuyenKhoaList
                            .map<DropdownMenuItem<int>>(
                              (ck) => DropdownMenuItem(
                                value: ck['maChuyenKhoa'],
                                child: Text(ck['tenChuyenKhoa']),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => maChuyenKhoa = value,
                    validator:
                        (value) =>
                            value == null ? "Vui lòng chọn chuyên khoa" : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: ngayLamViecController,
                    decoration: InputDecoration(
                      labelText: "Ngày làm việc (VD: T2;T4;T6)",
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
                                ? "Vui lòng nhập ngày làm việc"
                                : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: khungGioLamViecController,
                    decoration: InputDecoration(
                      labelText:
                          "Khung giờ làm việc (VD: 07:30-11:30;13:00-17:00)",
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
                                ? "Vui lòng nhập khung giờ"
                                : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: gioiThieuController,
                    decoration: InputDecoration(
                      labelText: "Giới thiệu",
                      prefixIcon: Icon(Icons.info_outline),
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: hinhAnhController,
                    decoration: InputDecoration(
                      labelText: "Link hình ảnh (nếu có)",
                      prefixIcon: Icon(Icons.image),
                    ),
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
                // Cập nhật thông tin người dùng
                final nguoiDungBody = {
                  "maNguoiDung": nguoiDung['maNguoiDung'],
                  "hoVaTen": tenController.text.trim(),
                  "email": emailController.text.trim(),
                  "matKhau": nguoiDung['matKhau'],
                  "vaiTro": "bác sĩ",
                  "ngayTao": nguoiDung['ngayTao'],
                };
                final respNguoiDung = await http.put(
                  Uri.parse(
                    'http://localhost:5001/api/NguoiDung/${nguoiDung['maNguoiDung']}',
                  ),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode(nguoiDungBody),
                );
                if (respNguoiDung.statusCode == 204 ||
                    respNguoiDung.statusCode == 200) {
                  // Cập nhật thông tin bác sĩ
                  final bacSiBody = {
                    "maBacSi": bs['maBacSi'],
                    "maNguoiDung": nguoiDung['maNguoiDung'],
                    "maChuyenKhoa": maChuyenKhoa,
                    "ngayLamViec": ngayLamViecController.text.trim(),
                    "khungGioLamViec": khungGioLamViecController.text.trim(),
                    "gioiThieu": gioiThieuController.text.trim(),
                    gioiTinh: gioiTinh ?? "",
                    "hinhAnh": hinhAnhController.text.trim(),
                    "ngayTao": bs['ngayTao'],
                  };
                  final respBacSi = await http.put(
                    Uri.parse(
                      'http://localhost:5001/api/BacSi/${bs['maBacSi']}',
                    ),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode(bacSiBody),
                  );
                  if (respBacSi.statusCode == 204 ||
                      respBacSi.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Cập nhật bác sĩ thành công")),
                    );
                    fetchBacSi();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Cập nhật bác sĩ thất bại (BacSi)"),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Cập nhật bác sĩ thất bại (NguoiDung)"),
                    ),
                  );
                }
              },
              child: Text("Lưu"),
            ),
          ],
        );
      },
    );
  }

  Widget buildBacSiCard(Map<String, dynamic> bs) {
    final nguoiDung = bs['nguoiDung'] ?? {};
    final chuyenKhoa = bs['chuyenKhoa'] ?? {};
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.blue[100],
              backgroundImage:
                  (nguoiDung['hinhAnh'] != null &&
                          nguoiDung['hinhAnh'].toString().isNotEmpty)
                      ? NetworkImage(nguoiDung['hinhAnh'])
                      : null,
              child:
                  (nguoiDung['hinhAnh'] == null ||
                          nguoiDung['hinhAnh'].toString().isEmpty)
                      ? Icon(Icons.person, color: Colors.blue[700], size: 36)
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bs['hoVaTen'] ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Text(
                        nguoiDung['email'] ?? "",
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  if (bs['gioiTinh'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Icon(Icons.wc, size: 16, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            bs['gioiTinh'] ?? "",
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                  if (chuyenKhoa['tenChuyenKhoa'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_hospital,
                            size: 16,
                            color: Colors.purple,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Chuyên khoa: ${chuyenKhoa['tenChuyenKhoa']}",
                            style: TextStyle(color: Colors.purple),
                          ),
                        ],
                      ),
                    ),
                  if (bs['ngayLamViec'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.teal,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Ngày làm việc: ${bs['ngayLamViec']}",
                            style: TextStyle(color: Colors.teal),
                          ),
                        ],
                      ),
                    ),
                  if (bs['khungGioLamViec'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Khung giờ: ${bs['khungGioLamViec']}",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  if (bs['ngayTao'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Ngày tạo: ${bs['ngayTao'].toString().substring(0, 10)}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (bs['gioiThieu'] != null &&
                      bs['gioiThieu'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        bs['gioiThieu'],
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "edit") {
                  showEditBacSiDialog(bs);
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: "edit",
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text("Chỉnh sửa"),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services, color: Colors.blue, size: 28),
            const SizedBox(width: 10),
            Text(
              "Quản Lý Bác Sĩ",
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
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
              onPressed: showAddBacSiDialog,
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.blue),
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
                      ? Center(child: Text("Không có bác sĩ nào"))
                      : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder:
                            (context, index) =>
                                buildBacSiCard(filteredList[index]),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
