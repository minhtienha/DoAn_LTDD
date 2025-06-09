import 'package:doan_nhom06/GiaoDien_BenhNhan/t_HoSoBenhNhan.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TaoHoSoBenhNhanScreen extends StatefulWidget {
  final int maNguoiDung;
  const TaoHoSoBenhNhanScreen({super.key, required this.maNguoiDung});

  @override
  State<TaoHoSoBenhNhanScreen> createState() => _TaoHoSoBenhNhanScreenState();
}

class _TaoHoSoBenhNhanScreenState extends State<TaoHoSoBenhNhanScreen> {
  String? _gioiTinh;
  DateTime? _ngaySinh;
  final _hoTenController = TextEditingController();
  final _moiQuanHeController = TextEditingController(text: 'Bản thân');

  bool _loading = false;

  Future<void> _chonNgaySinh(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _ngaySinh = picked);
  }

  void _chonGioiTinh() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Wrap(
            children:
                ['Nam', 'Nữ'].map((gt) {
                  return ListTile(
                    title: Text(gt),
                    onTap: () {
                      setState(() => _gioiTinh = gt);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
          ),
    );
  }

  String? _validate() {
    if (_hoTenController.text.trim().isEmpty)
      return 'Vui lòng nhập tên bệnh nhân';
    if (_ngaySinh == null) return 'Vui lòng chọn ngày sinh';
    if (_gioiTinh == null) return 'Vui lòng chọn giới tính';
    if (_moiQuanHeController.text.trim().isEmpty)
      return 'Vui lòng nhập mối quan hệ';
    return null;
  }

  Future<void> _submit() async {
    final err = _validate();
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    setState(() => _loading = true);
    final body = {
      "maNguoiDung": widget.maNguoiDung,
      "hoVaTen": _hoTenController.text.trim(),
      "ngaySinh":
          "${_ngaySinh!.year}-${_ngaySinh!.month.toString().padLeft(2, '0')}-${_ngaySinh!.day.toString().padLeft(2, '0')}",
      "gioiTinh": _gioiTinh,
      "moiQuanHe": _moiQuanHeController.text.trim(),
      "ngayTao": DateTime.now().toIso8601String(),
    };

    try {
      final resp = await http.post(
        Uri.parse('http://localhost:5001/api/HoSoBenhNhan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      setState(() => _loading = false);

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    HoSoBenhNhanScreen(maNguoiDung: widget.maNguoiDung),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi server: ${resp.body}')));
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi kết nối: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo hồ sơ bệnh nhân'),
        backgroundColor: const Color(0xFF0165FC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Họ và tên *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _hoTenController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Ngày sinh *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                readOnly: true,
                onTap: () => _chonNgaySinh(context),
                decoration: InputDecoration(
                  hintText:
                      _ngaySinh != null
                          ? '${_ngaySinh!.day}/${_ngaySinh!.month}/${_ngaySinh!.year}'
                          : 'Chọn ngày sinh',
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Giới tính *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                readOnly: true,
                onTap: _chonGioiTinh,
                decoration: InputDecoration(
                  hintText: _gioiTinh ?? 'Chọn giới tính',
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Mối quan hệ *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _moiQuanHeController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child:
                      _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Tạo hồ sơ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
