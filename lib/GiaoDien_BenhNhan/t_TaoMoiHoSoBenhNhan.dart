import 'package:flutter/material.dart';

class TaoHoSoBenhNhanScreen extends StatefulWidget {
  const TaoHoSoBenhNhanScreen({super.key});

  @override
  State<TaoHoSoBenhNhanScreen> createState() => _TaoHoSoBenhNhanScreenState();
}

class _TaoHoSoBenhNhanScreenState extends State<TaoHoSoBenhNhanScreen> {
  String? _gioiTinh;
  DateTime? _ngaySinh;
  final _hoTenController = TextEditingController();
  final _soDienThoaiController = TextEditingController();
  final _emailController = TextEditingController();
  final _thanhPhoController = TextEditingController();

  Future<void> _chonNgaySinh(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _ngaySinh = picked);
    }
  }

  void _chonGioiTinh() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children:
              ['Nam', 'Nữ']
                  .map(
                    (gioiTinh) => ListTile(
                      title: Text(gioiTinh),
                      onTap: () {
                        setState(() {
                          _gioiTinh = gioiTinh;
                          Navigator.pop(context);
                        });
                      },
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tạo hồ sơ bệnh nhân",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0165FC),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Họ và tên *",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _hoTenController,
                decoration: InputDecoration(
                  hintText: "Nhập họ và tên",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Số điện thoại *",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _soDienThoaiController,
                decoration: InputDecoration(
                  hintText: "Nhập số điện thoại",
                  prefixText: "+84 ",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Email ",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Nhập email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ngày sinh *",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          readOnly: true,
                          onTap: () => _chonNgaySinh(context),
                          decoration: InputDecoration(
                            hintText:
                                _ngaySinh != null
                                    ? "${_ngaySinh!.day}/${_ngaySinh!.month}/${_ngaySinh!.year}"
                                    : "Ngày / Tháng / Năm",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: const Icon(
                              Icons.calendar_today,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Giới tính *",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          readOnly: true,
                          onTap: _chonGioiTinh,
                          decoration: InputDecoration(
                            hintText: _gioiTinh ?? "Giới tính",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text(
                "Địa chỉ thường trú *",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _thanhPhoController,
                decoration: InputDecoration(
                  hintText: "Nhập địa chỉ thường trú",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF0165FC),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Tạo mới hồ sơ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
