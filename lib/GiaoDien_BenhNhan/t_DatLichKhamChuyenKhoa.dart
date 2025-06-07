import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 't_DanhSachLichChon.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/trangChu.dart';

/// Mô hình khung giờ từ [start] → [end]
class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;
  TimeRange({required this.start, required this.end});
}

/// Chuyển "T3" → weekday (1=Thứ Hai ... 7=Chủ Nhật)
int weekdayFromLabel(String label) {
  label = label.trim().toUpperCase();
  if (label.startsWith('T')) {
    final n = int.tryParse(label.substring(1));
    if (n != null && n >= 2 && n <= 7) return n - 1;
  }
  throw FormatException('Không đọc được thứ: $label');
}

/// Tách "T3:07:30-11:30;T6:13:00-17:00" → map weekday→List<TimeRange>
Map<int, List<TimeRange>> parseLichLamViec(String raw) {
  final out = <int, List<TimeRange>>{};
  for (final part in raw.split(';')) {
    final p = part.trim();
    if (p.isEmpty) continue;
    final kv = p.split(':');
    if (kv.length < 2) continue;
    int wd;
    try {
      wd = weekdayFromLabel(kv[0]);
    } catch (_) {
      continue;
    }
    final times = kv.sublist(1).join(':').split('-');
    if (times.length != 2) continue;
    final sh = times[0].split(':'), eh = times[1].split(':');
    final start = TimeOfDay(hour: int.parse(sh[0]), minute: int.parse(sh[1]));
    final end = TimeOfDay(hour: int.parse(eh[0]), minute: int.parse(eh[1]));
    out.putIfAbsent(wd, () => []).add(TimeRange(start: start, end: end));
  }
  return out;
}

/// Chia mỗi khoảng > 1h thành các slot 1h
List<TimeRange> splitHourly(TimeRange r) {
  final slots = <TimeRange>[];
  var curr = r.start.hour * 60 + r.start.minute;
  final end = r.end.hour * 60 + r.end.minute;
  while (curr + 60 <= end) {
    final sH = curr ~/ 60, sM = curr % 60;
    final eT = curr + 60;
    slots.add(
      TimeRange(
        start: TimeOfDay(hour: sH, minute: sM),
        end: TimeOfDay(hour: eT ~/ 60, minute: eT % 60),
      ),
    );
    curr += 60;
  }
  return slots;
}

/// Model bác sĩ cùng lịch làm việc dạng chuỗi (không cần model API riêng)
class Doctor {
  final String name;
  final String specialty;
  final String lichLamViec;
  late final Map<int, List<TimeRange>> schedule = parseLichLamViec(lichLamViec);

  Doctor({
    required this.name,
    required this.specialty,
    required this.lichLamViec,
  });
}

class ChonChuyenKhoaScreen extends StatefulWidget {
  final Map<String, dynamic> hoSo;

  const ChonChuyenKhoaScreen({super.key, required this.hoSo});
  @override
  State<ChonChuyenKhoaScreen> createState() => _ChonChuyenKhoaScreenState();
}

class _ChonChuyenKhoaScreenState extends State<ChonChuyenKhoaScreen> {
  // BASE URL của API
  static const baseUrl = "http://localhost:5001/api";

  // --- Danh sách chuyên khoa từ API ---
  List<String> chuyenKhoaList = [];
  bool loadingCK = true;
  String? errCK;
  String? selectedCK;

  // --- Danh sách bác sĩ từ API ---
  List<Doctor> doctors = [];
  bool loadingDocs = true;
  String? errDocs;

  // --- Chọn ngày + slot ---
  DateTime? selectedDate;
  List<Doctor> availDocs = [];
  Map<Doctor, List<TimeRange>> docSlots = {};

  // *** Chỉ chọn 1 bác sĩ và 1 khung giờ ***
  Doctor? selectedDoctor;
  String? selectedSlot;

  // Danh sách tạm để lưu lịch đặt
  List<Map<String, dynamic>> selectedBookings = [];

  bool hasInsurance = false;

  @override
  void initState() {
    super.initState();
    _loadChuyenKhoa();
    _loadDoctors();
  }

  /// Tải danh sách chuyên khoa
  Future<void> _loadChuyenKhoa() async {
    setState(() {
      loadingCK = true;
      errCK = null;
    });
    try {
      final resp = await http.get(Uri.parse("$baseUrl/ChuyenKhoa"));
      if (resp.statusCode == 200) {
        final js = jsonDecode(resp.body) as List;
        chuyenKhoaList =
            js
                .whereType<Map<String, dynamic>>()
                .where((m) => m.containsKey("tenChuyenKhoa"))
                .map((m) => m["tenChuyenKhoa"] as String)
                .toList();
      } else {
        errCK = "Lỗi server: ${resp.statusCode}";
      }
    } catch (e) {
      errCK = "Không thể kết nối: $e";
    }
    setState(() {
      loadingCK = false;
    });
  }

  /// Tải danh sách bác sĩ
  Future<void> _loadDoctors() async {
    setState(() {
      loadingDocs = true;
      errDocs = null;
    });
    try {
      final resp = await http.get(Uri.parse("$baseUrl/BacSi"));
      if (resp.statusCode == 200) {
        final js = jsonDecode(resp.body) as List;
        doctors =
            js.whereType<Map<String, dynamic>>().map((m) {
              final hoVaTen = m["hoVaTen"] as String? ?? "";
              final ckMap = m["chuyenKhoa"] as Map<String, dynamic>?;
              final tenCK =
                  ckMap != null
                      ? (ckMap["tenChuyenKhoa"] as String? ?? "")
                      : "";
              final lich = m["lichLamViec"] as String? ?? "";
              return Doctor(name: hoVaTen, specialty: tenCK, lichLamViec: lich);
            }).toList();
      } else {
        errDocs = "Lỗi server: ${resp.statusCode}";
      }
    } catch (e) {
      errDocs = "Không thể kết nối: $e";
    }
    setState(() {
      loadingDocs = false;
    });
  }

  /// Chọn chuyên khoa
  void _pickChuyenKhoa() {
    if (loadingCK) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đang tải chuyên khoa...")));
      return;
    }
    if (errCK != null) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Lỗi"),
              content: Text(errCK!),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _loadChuyenKhoa();
                  },
                  child: const Text("Thử lại"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Đóng"),
                ),
              ],
            ),
      );
      return;
    }
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Chọn chuyên khoa"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: chuyenKhoaList.length,
                itemBuilder: (_, i) {
                  final ck = chuyenKhoaList[i];
                  return ListTile(
                    title: Text(
                      ck,
                      style: TextStyle(
                        fontWeight:
                            selectedCK == ck
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedCK = ck;
                        selectedDate = null;
                        availDocs.clear();
                        docSlots.clear();
                        selectedDoctor = null;
                        selectedSlot = null;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
    );
  }

  /// Chọn ngày
  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d != null) {
      setState(() {
        selectedDate = d;
        selectedDoctor = null;
        selectedSlot = null;
      });
      _filterDoctors();
    }
  }

  /// Lọc bác sĩ ra những người làm việc đúng chuyên khoa và thứ
  void _filterDoctors() {
    if (selectedCK == null || selectedDate == null) {
      setState(() {
        availDocs.clear();
        docSlots.clear();
      });
      return;
    }
    final wd = selectedDate!.weekday; // 1=Thứ Hai … 7=CN
    final tmpDocs = <Doctor>[];
    final tmpMap = <Doctor, List<TimeRange>>{};
    for (var doc in doctors) {
      if (doc.specialty != selectedCK) continue;
      final ranges = doc.schedule[wd] ?? [];
      if (ranges.isEmpty) continue;
      final slots = <TimeRange>[];
      for (var r in ranges) {
        slots.addAll(splitHourly(r));
      }
      if (slots.isNotEmpty) {
        tmpDocs.add(doc);
        tmpMap[doc] = slots;
      }
    }
    setState(() {
      availDocs = tmpDocs;
      docSlots = tmpMap;
    });
  }

  /// Xác nhận
  void _confirm() {
    if (selectedCK == null ||
        selectedDate == null ||
        availDocs.isEmpty ||
        selectedDoctor == null ||
        selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng chọn chuyên khoa, ngày, bác sĩ và khung giờ"),
        ),
      );
      return;
    }

    // ✅ Lưu lịch vào danh sách tạm trước khi chuyển trang
    final bookingData = {
      "hoSoId": widget.hoSo["id"],
      "tenHoSo": widget.hoSo["ten"],
      "chuyenKhoa": selectedCK,
      "ngayKham":
          "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
      "bacSi": selectedDoctor!.name,
      "khungGio": selectedSlot,
    };

    selectedBookings.add(bookingData);

    // ✅ Chuyển sang trang danh sách lịch chưa thanh toán, truyền danh sách tạm
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => DanhSachLichChuaThanhToanScreen(
              selectedBookings: selectedBookings,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chọn chuyên khoa",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0165FC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chuyên khoa
            const Text(
              "Chọn chuyên khoa:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickChuyenKhoa,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
              ),
              child: Text(selectedCK ?? "Chọn chuyên khoa"),
            ),
            const SizedBox(height: 20),

            // Ngày
            const Text(
              "Chọn ngày khám:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickDate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
              ),
              child: Text(
                selectedDate != null
                    ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                    : "Chọn ngày",
              ),
            ),
            const SizedBox(height: 20),

            // Danh sách bác sĩ + khung giờ
            if (selectedDate != null)
              Expanded(
                child:
                    availDocs.isEmpty
                        ? const Center(
                          child: Text(
                            "Không có bác sĩ làm việc trong ngày này",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                        : ListView.builder(
                          itemCount: availDocs.length,
                          itemBuilder: (_, i) {
                            final doc = availDocs[i];
                            final slots = docSlots[doc]!;
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text("Chuyên khoa: ${doc.specialty}"),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Khung giờ khả dụng:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 3,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                          ),
                                      itemCount: slots.length,
                                      itemBuilder: (_, j) {
                                        final r = slots[j];
                                        final lbl =
                                            "${r.start.format(ctx)} - ${r.end.format(ctx)}";
                                        final isSel =
                                            (doc == selectedDoctor &&
                                                lbl == selectedSlot);
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (isSel) {
                                                selectedDoctor = null;
                                                selectedSlot = null;
                                              } else {
                                                selectedDoctor = doc;
                                                selectedSlot = lbl;
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  isSel
                                                      ? Colors.blue
                                                      : Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color:
                                                    isSel
                                                        ? Colors.blue.shade800
                                                        : Colors.blue.shade200,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              lbl,
                                              style: TextStyle(
                                                color:
                                                    isSel
                                                        ? Colors.white
                                                        : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),

            const SizedBox(height: 8),

            const SizedBox(height: 16),

            // Xác nhận
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0165FC),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Xác nhận đặt lịch",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
