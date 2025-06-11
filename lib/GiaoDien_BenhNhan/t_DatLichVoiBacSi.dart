import 'dart:convert';

import 'package:flutter/material.dart';
import 't_DanhSachLichChon.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/trangChu.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class DatLichBacSi extends StatefulWidget {
  final int userId;
  final Map<String, dynamic> hoSo;
  final Map<String, dynamic> bacSi;
  final List<Map<String, dynamic>> selectedBookings;
  const DatLichBacSi({
    super.key,
    required this.hoSo,
    required this.bacSi,
    required this.userId,
    required this.selectedBookings,
  });

  @override
  State<DatLichBacSi> createState() => _DatLichBacSiState();
}

class TimeRange {
  final String start;
  final String end;

  TimeRange({required this.start, required this.end});
}

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String lichLamViec;
  late final Map<int, List<TimeRange>> schedule = parseLichLamViec(lichLamViec);

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.lichLamViec,
  });
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
    out
        .putIfAbsent(wd, () => [])
        .add(
          TimeRange(
            start:
                "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}",
            end:
                "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}",
          ),
        );
  }
  return out;
}

class _DatLichBacSiState extends State<DatLichBacSi> {
  DateTime? _selectedDate;
  String? _selectedTime;
  late List<Map<String, dynamic>> selectedBookings;
  List<String> availableTimes = [];

  @override
  void initState() {
    super.initState();
    selectedBookings = widget.selectedBookings;
  }

  Future<void> _chonNgay(BuildContext context) async {
    // Tách danh sách các thứ bác sĩ làm từ "T2: 07:30-11:30; T5: 13:00-17:00"
    List<int> allowedWeekdays = [];
    for (final part in widget.bacSi["lichLamViec"].split(';')) {
      final weekdayLabel = part.split(':')[0].trim();
      try {
        final wd = weekdayFromLabel(weekdayLabel);
        allowedWeekdays.add(wd);
      } catch (e) {
        print("🚨 Lỗi khi chuyển đổi ngày làm việc: $e");
      }
    }
    // Bộ lọc để chỉ hiển thị ngày có trong `allowedWeekdays`
    var initialValidDate = DateTime.now();
    while (!allowedWeekdays.contains(initialValidDate.weekday)) {
      initialValidDate = initialValidDate.add(const Duration(days: 1));
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialValidDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate:
          (DateTime day) => allowedWeekdays.contains(day.weekday),
    );

    List<String> generateTimeSlots(String rawLichLamViec, int selectedWeekday) {
      List<String> timeSlots = [];

      for (final part in rawLichLamViec.split(';')) {
        final kv = part.split(':');
        if (kv.length < 2) continue;

        final wd = weekdayFromLabel(kv[0].trim());
        if (wd != selectedWeekday) continue;

        final times = kv.sublist(1).join(':').split('-');
        if (times.length != 2) continue;

        final startParts = times[0].split(':');
        final endParts = times[1].split(':');

        int startHour = int.parse(startParts[0]);
        int startMin = int.parse(startParts[1]);
        int endHour = int.parse(endParts[0]);
        int endMin = int.parse(endParts[1]);

        DateTime current = DateTime(2000, 1, 1, startHour, startMin);
        DateTime end = DateTime(2000, 1, 1, endHour, endMin);

        while (current.add(const Duration(hours: 1)).compareTo(end) <= 0) {
          final slotStart =
              "${current.hour.toString().padLeft(2, '0')}:${current.minute.toString().padLeft(2, '0')}";
          final next = current.add(const Duration(hours: 1));
          final slotEnd =
              "${next.hour.toString().padLeft(2, '0')}:${next.minute.toString().padLeft(2, '0')}";
          timeSlots.add("$slotStart - $slotEnd");
          current = next;
        }
      }

      return timeSlots;
    }

    Future<List<String>> fetchBookedSlots(int bacSiId, DateTime date) async {
      final dateStr =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final url =
          "${getBaseUrl()}api/LichKham/BacSiNgay?maBacSi=$bacSiId&ngay=$dateStr";
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        final List<dynamic> times = jsonDecode(resp.body);
        return times.map((t) {
          final dt = DateTime.parse(t);
          return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
        }).toList();
      }
      return [];
    }

    if (pickedDate != null) {
      List<String> times = generateTimeSlots(
        widget.bacSi["lichLamViec"],
        pickedDate.weekday,
      );

      final bacSiId = widget.bacSi['id'];
      Set<String> bookedDB = {};
      try {
        final booked = await fetchBookedSlots(bacSiId, pickedDate);
        bookedDB = booked.toSet();
      } catch (e) {
        print("Lỗi fetch slot đã đặt: $e");
      }

      times =
          times.where((slot) {
            final slotStart = slot.split('-')[0].trim();
            return !bookedDB.contains(slotStart);
          }).toList();

      setState(() {
        _selectedDate = pickedDate;
        _selectedTime = null;
        availableTimes = times;
      });
    }
  }

  void confirm() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn ngày và giờ khám")),
      );
      return;
    }

    final newDate =
        "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
    final newStart = _selectedTime!.split('-')[0].trim();

    // Kiểm tra trùng lịch
    final isTrung = selectedBookings.any((lich) {
      if (lich["ngayKham"] != newDate) return false;
      final existStart = lich["khungGio"].split('-')[0].trim();
      if (existStart == newStart) return true;
      final existStartTime = TimeOfDay(
        hour: int.parse(existStart.split(':')[0]),
        minute: int.parse(existStart.split(':')[1]),
      );
      final existEnd = lich["khungGio"].split('-')[1].trim();
      final existEndTime = TimeOfDay(
        hour: int.parse(existEnd.split(':')[0]),
        minute: int.parse(existEnd.split(':')[1]),
      );
      final newStartTime = TimeOfDay(
        hour: int.parse(newStart.split(':')[0]),
        minute: int.parse(newStart.split(':')[1]),
      );
      final existStartMinutes =
          existStartTime.hour * 60 + existStartTime.minute;
      final existEndMinutes = existEndTime.hour * 60 + existEndTime.minute;
      final newStartMinutes = newStartTime.hour * 60 + newStartTime.minute;
      return newStartMinutes >= existStartMinutes &&
          newStartMinutes < existEndMinutes;
    });

    if (isTrung) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bạn đã có lịch trùng khung giờ này!")),
      );
      return;
    }

    final bookingData = {
      "hoSoId": widget.hoSo["id"],
      "tenHoSo": widget.hoSo["ten"],
      "chuyenKhoa": widget.bacSi["chuyenKhoa"],
      "gia": widget.bacSi["gia"],
      "ngayKham": newDate,
      "bacSiId": widget.bacSi["id"],
      "bacSiTen": widget.bacSi["ten"],
      "khungGio": _selectedTime,
    };

    selectedBookings.add(bookingData);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => DanhSachLichChuaThanhToanScreen(
              hoSo: widget.bacSi,
              userId: widget.userId,
              ngayChon: _selectedDate,
              selectedBookings: selectedBookings,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Xác nhận lịch hẹn",
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
            const Text(
              "Bác sĩ:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("${widget.bacSi["ten"]}", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            const Text(
              "Chuyên khoa:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.bacSi["chuyenKhoa"]}",
              style: TextStyle(fontSize: 16),
            ),
            const Divider(height: 30),

            const Text(
              "Chọn ngày:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _chonNgay(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
              ),
              child: Text(
                _selectedDate != null
                    ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                    : "Chọn ngày",
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Chọn giờ:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  availableTimes.isEmpty
                      ? const Center(
                        child: Text("Không có giờ làm việc hợp lệ!"),
                      )
                      : ListView.builder(
                        itemCount: availableTimes.length,
                        itemBuilder: (context, index) {
                          final timeSlot = availableTimes[index];
                          bool isSelected = _selectedTime == timeSlot;

                          int hour = int.parse(timeSlot.split(":")[0]);
                          Color backgroundColor =
                              (hour < 12) ? Colors.green : Colors.orange;

                          return GestureDetector(
                            onTap:
                                () => setState(
                                  () =>
                                      _selectedTime =
                                          isSelected ? null : timeSlot,
                                ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFF0165FC)
                                        : backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                timeSlot,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0165FC),
                  foregroundColor: Colors.white,
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
