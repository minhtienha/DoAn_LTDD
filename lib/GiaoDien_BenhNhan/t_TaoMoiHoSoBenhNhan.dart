import 'package:doan_nhom06/GiaoDien_BenhNhan/t_HoSoBenhNhan.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

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
  List<Map<String, dynamic>> _existingProfiles = [];

  @override
  void initState() {
    super.initState();
    _fetchExistingProfiles();
  }

  Future<void> _fetchExistingProfiles() async {
    try {
      final resp = await http.get(
        Uri.parse(
          '${getBaseUrl()}api/HoSoBenhNhan?maNguoiDung=${widget.maNguoiDung}',
        ),
      );
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List;
        setState(() {
          _existingProfiles = data.whereType<Map<String, dynamic>>().toList();
        });
      }
    } catch (_) {}
  }

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
    final name = _hoTenController.text.trim();
    if (name.isEmpty) return 'Vui lòng nhập tên bệnh nhân';
    if (_ngaySinh == null) return 'Vui lòng chọn ngày sinh';
    if (_gioiTinh == null) return 'Vui lòng chọn giới tính';
    final relation = _moiQuanHeController.text.trim();
    if (relation.isEmpty) return 'Vui lòng nhập mối quan hệ';

    // Kiểm tra trùng: so sánh tên và ngày sinh
    final exists = _existingProfiles.any((p) {
      final existingName = p['hoVaTen']?.toString().trim() ?? '';
      if (existingName != name) return false;
      try {
        final existingDate = DateTime.parse(p['ngaySinh'].toString());
        return existingDate.year == _ngaySinh!.year &&
            existingDate.month == _ngaySinh!.month &&
            existingDate.day == _ngaySinh!.day;
      } catch (_) {
        return false;
      }
    });
    if (exists) return 'Hồ sơ này đã tồn tại';

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
          '${_ngaySinh!.year}-${_ngaySinh!.month.toString().padLeft(2, '0')}-${_ngaySinh!.day.toString().padLeft(2, '0')}',
      "gioiTinh": _gioiTinh,
      "moiQuanHe": _moiQuanHeController.text.trim(),
      "ngayTao": DateTime.now().toIso8601String(),
    };

    try {
      final resp = await http.post(
        Uri.parse('${getBaseUrl()}api/HoSoBenhNhan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      setState(() => _loading = false);

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        Navigator.pop(context, true);
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
