import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

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
  bool showActive = true;

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
    }
    setState(() => loading = false);
    _filterBacSi(); // gọi sau setState để lọc lại và cập nhật filteredList
  }

  void filterSearch(String value) {
    setState(() {
      searchText = value;
      _filterBacSi();
    });
  }

  void _filterBacSi() {
    List<dynamic> tempList = bacSiList;

    if (showActive) {
      tempList =
          tempList
              .where(
                (bs) =>
                    bs['daXoa'] == false ||
                    bs['daXoa'] == 0 ||
                    bs['daXoa'] == null,
              )
              .toList();
    } else {
      tempList =
          tempList
              .where((bs) => bs['daXoa'] == true || bs['daXoa'] == 1)
              .toList();
    }

    if (searchText.isNotEmpty) {
      final searchLower = searchText.toLowerCase();
      tempList =
          tempList.where((e) {
            final name = (e['hoVaTen'] ?? '').toString().toLowerCase();
            final email =
                (e['nguoiDung']?['email'] ?? '').toString().toLowerCase();
            return name.contains(searchLower) || email.contains(searchLower);
          }).toList();
    }

    setState(() {
      filteredList = tempList;
    });
  }

  Future<void> setDaXoaBacSi(int maBacSi, bool daXoa) async {
    final resp = await http.put(
      Uri.parse('${getBaseUrl()}api/BacSi/SetDaXoa/$maBacSi'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(daXoa),
    );

    if (resp.statusCode == 200 || resp.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(daXoa ? "Đã ẩn bác sĩ" : "Đã kích hoạt lại bác sĩ"),
        ),
      );
      fetchBacSi();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cập nhật trạng thái bác sĩ thất bại")),
      );
    }
  }

  void showAddBacSiDialog() async {
    final formKey = GlobalKey<FormState>();
    final tenController = TextEditingController();
    final emailController = TextEditingController();
    final matKhauController = TextEditingController();
    final gioiThieuController = TextEditingController();
    String? gioiTinh;
    int? maChuyenKhoa;
    Uint8List? imageBytes;
    String? imageBase64;

    List<String> selectedDays = []; // Lưu các thứ được chọn
    List<String> selectedShifts = []; // Lưu các ca được chọn

    // Các ca mẫu
    const shifts = ["07:30-11:30", "13:00-17:00"];

    // Lấy danh sách chuyên khoa từ API
    List<dynamic> chuyenKhoaList = [];
    final resp = await http.get(Uri.parse('${getBaseUrl()}api/ChuyenKhoa'));
    if (resp.statusCode == 200) {
      chuyenKhoaList =
          (jsonDecode(resp.body) as List).where((e) {
            final daXoa = e['daXoa'];
            if (daXoa == null) return true;
            if (daXoa is bool) return daXoa == false;
            if (daXoa is int) return daXoa == 0;
            return false;
          }).toList();
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chọn ngày làm việc:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 8,
                            children: List.generate(5, (i) {
                              final dayLabel = 'T${i + 2}'; // T2 đến T6
                              return FilterChip(
                                label: Text(dayLabel),
                                selected: selectedDays.contains(dayLabel),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedDays.add(dayLabel);
                                    } else {
                                      selectedDays.remove(dayLabel);
                                    }
                                  });
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chọn ca làm việc:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 8,
                            children:
                                shifts
                                    .map(
                                      (shift) => FilterChip(
                                        label: Text(shift),
                                        selected: selectedShifts.contains(
                                          shift,
                                        ),
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              selectedShifts.add(shift);
                                            } else {
                                              selectedShifts.remove(shift);
                                            }
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
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

                    // Thêm đoạn kiểm tra chọn ngày và ca làm việc ở đây
                    if (selectedDays.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Vui lòng chọn ít nhất một ngày làm việc!",
                          ),
                        ),
                      );
                      return;
                    }
                    if (selectedShifts.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Vui lòng chọn ít nhất một ca làm việc!",
                          ),
                        ),
                      );
                      return;
                    }

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
                        "ngayLamViec": selectedDays.join(";"),
                        "khungGioLamViec": selectedShifts.join(";"),
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
    final matKhauController = TextEditingController(
      text: nguoiDung['matKhau'] ?? "",
    );
    final gioiThieuController = TextEditingController(
      text: bs['gioiThieu'] ?? "",
    );

    List<String> selectedDays =
        (bs['ngayLamViec'] ?? "")
            .toString()
            .split(';')
            .where((e) => e.isNotEmpty)
            .toList();
    List<String> selectedShifts =
        (bs['khungGioLamViec'] ?? "")
            .toString()
            .split(';')
            .where((e) => e.isNotEmpty)
            .toList();

    String? gioiTinh = bs['gioiTinh'];
    int? maChuyenKhoa = chuyenKhoa['maChuyenKhoa'];

    Uint8List? imageBytes;
    String? imageBase64;
    String? imageUrl = nguoiDung['hinhAnh'];

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
        imageUrl = null; // xóa URL cũ khi chọn ảnh mới
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Chỉnh sửa Bác Sĩ"),
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
                                  : ((imageUrl?.isNotEmpty ?? false)
                                      ? NetworkImage(imageUrl!)
                                      : null),
                          child:
                              (imageBytes == null &&
                                      !(imageUrl?.isNotEmpty ?? false))
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
                        readOnly: true,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chọn ngày làm việc:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 8,
                            children: List.generate(5, (i) {
                              final dayLabel = 'T${i + 2}'; // T2 đến T6
                              return FilterChip(
                                label: Text(dayLabel),
                                selected: selectedDays.contains(dayLabel),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedDays.add(dayLabel);
                                    } else {
                                      selectedDays.remove(dayLabel);
                                    }
                                  });
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chọn ca làm việc:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 8,
                            children:
                                ["07:30-11:30", "13:00-17:00"]
                                    .map(
                                      (shift) => FilterChip(
                                        label: Text(shift),
                                        selected: selectedShifts.contains(
                                          shift,
                                        ),
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              selectedShifts.add(shift);
                                            } else {
                                              selectedShifts.remove(shift);
                                            }
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
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

                    if (selectedDays.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Vui lòng chọn ít nhất một ngày làm việc!",
                          ),
                        ),
                      );
                      return;
                    }
                    if (selectedShifts.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Vui lòng chọn ít nhất một ca làm việc!",
                          ),
                        ),
                      );
                      return;
                    }
                    // Cập nhật người dùng
                    final nguoiDungBody = {
                      "maNguoiDung": nguoiDung['maNguoiDung'],
                      "hoVaTen": tenController.text.trim(),
                      "email": emailController.text.trim(),
                      "matKhau": matKhauController.text,
                      "vaiTro": "bác sĩ",
                      "ngayTao": nguoiDung['ngayTao'],
                    };
                    final respNguoiDung = await http.put(
                      Uri.parse(
                        '${getBaseUrl()}api/NguoiDung/${nguoiDung['maNguoiDung']}',
                      ),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode(nguoiDungBody),
                    );
                    print(jsonEncode(nguoiDung));
                    if (respNguoiDung.statusCode == 204 ||
                        respNguoiDung.statusCode == 200) {
                      // Cập nhật bác sĩ
                      final respBacSi = await http.put(
                        Uri.parse(
                          '${getBaseUrl()}api/BacSi/${bs['maBacSi']}',
                        ), // id ở URL
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode({
                          "hoVaTen": tenController.text.trim(),
                          "maNguoiDung": nguoiDung['maNguoiDung'],
                          "maChuyenKhoa": maChuyenKhoa,
                          "ngayLamViec": selectedDays.join(";"),
                          "khungGioLamViec": selectedShifts.join(";"),
                          "gioiThieu": gioiThieuController.text.trim(),
                          "gioiTinh": gioiTinh ?? "",
                          "ngayTao": bs['ngayTao'],
                          "hinhAnh": imageBase64,
                        }),
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
                          content: Text(
                            "Cập nhật bác sĩ thất bại (Người dùng)",
                          ),
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
      },
    );
  }

  Widget buildBacSiCard(Map<String, dynamic> bs) {
    final nguoiDung = bs['nguoiDung'] ?? {};
    final chuyenKhoa = bs['chuyenKhoa'] ?? {};
    final isDeleted = bs['daXoa'] == true || bs['daXoa'] == 1;

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
                            "Giờ: ${bs['khungGioLamViec']}",
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
                            bs['ngayTao'].toString().substring(0, 10),
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
              onSelected: (value) async {
                if (value == "edit") {
                  showEditBacSiDialog(bs);
                } else if (value == "delete") {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text("Xác nhận"),
                          content: Text(
                            "Bạn có chắc muốn ẩn bác sĩ này không?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text("Hủy"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () => Navigator.pop(context, true),
                              child: Text("Ẩn"),
                            ),
                          ],
                        ),
                  );
                  if (confirm == true) {
                    await setDaXoaBacSi(bs['maBacSi'], true);
                  }
                } else if (value == "reactivate") {
                  await setDaXoaBacSi(bs['maBacSi'], false);
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
                    if (isDeleted)
                      PopupMenuItem(
                        value: "reactivate",
                        child: Row(
                          children: [
                            Icon(Icons.restore, color: Colors.green),
                            SizedBox(width: 8),
                            Text("Kích hoạt lại"),
                          ],
                        ),
                      )
                    else
                      PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text("Ẩn bác sĩ"),
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
        backgroundColor: const Color(0xFF0165FC),
        elevation: 2,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 28,
            ), // đổi icon màu trắng
            SizedBox(width: 10),
            Text(
              "Quản Lý Bác Sĩ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
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
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Tìm kiếm bác sĩ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.blue[50],
              ),
              onChanged: filterSearch,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showActive ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      showActive = true;
                      _filterBacSi();
                    });
                  },
                  child: Text(
                    "Đang làm việc",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !showActive ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      showActive = false;
                      _filterBacSi();
                    });
                  },
                  child: Text(
                    "Đã nghỉ việc",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
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
