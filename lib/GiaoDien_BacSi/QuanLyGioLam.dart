import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuanLyLichLamViec extends StatefulWidget {
  const QuanLyLichLamViec({super.key});

  @override
  State<QuanLyLichLamViec> createState() => _QuanLyLichLamViecState();
}

class _QuanLyLichLamViecState extends State<QuanLyLichLamViec> {
  DateTime? _selectedDate;
  final Map<DateTime, bool> _trangThaiNgay = {};
  final Map<DateTime, String> _caLamViec = {};
  final List<String> caLam = [
    "Ca sáng (08:00 - 12:00)",
    "Ca chiều (13:00 - 17:00)",
    "Cả ngày (08:00 - 17:00)",
  ];

  void _chonNgay() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        if (!_trangThaiNgay.containsKey(pickedDate)) {
          _trangThaiNgay[pickedDate] = true;
        }
        if (!_caLamViec.containsKey(pickedDate)) {
          _caLamViec[pickedDate] = caLam[2]; // Mặc định chọn "Cả ngày"
        }
      });
    }
  }

  void _luuThongTin() {
    if (_selectedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      String trangThai =
          _trangThaiNgay[_selectedDate!]! ? "Có mặt" : "Vắng mặt";
      String ca = _caLamViec[_selectedDate!] ?? "Không chọn";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đã cập nhật ngày $formattedDate: $trangThai - $ca"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quản Lý Lịch Làm Việc",
          style: TextStyle(color: Colors.white),
        ),
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
              onPressed: _chonNgay,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    _selectedDate == null
                        ? "Chọn ngày làm việc"
                        : "Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedDate != null) ...[
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Trạng thái ngày ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SwitchListTile(
                        title: Text(
                          _trangThaiNgay[_selectedDate!]!
                              ? "Có mặt"
                              : "Vắng mặt",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                _trangThaiNgay[_selectedDate!]!
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                        value: _trangThaiNgay[_selectedDate!]!,
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            _trangThaiNgay[_selectedDate!] = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _caLamViec[_selectedDate!],
                        items:
                            caLam.map((ca) {
                              return DropdownMenuItem(
                                value: ca,
                                child: Text(ca),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _caLamViec[_selectedDate!] = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Chọn ca làm việc",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _luuThongTin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Lưu thông tin",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
