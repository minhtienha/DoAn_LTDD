import 'package:flutter/material.dart';
import 't_DanhSachLichChon.dart';

class DatLichBacSi extends StatefulWidget {
  const DatLichBacSi({super.key});

  @override
  State<DatLichBacSi> createState() => _DatLichBacSiState();
}

class _DatLichBacSiState extends State<DatLichBacSi> {
  DateTime? _selectedDate;
  String? _selectedTime;
  bool _hasInsurance = false;

  Future<void> _chonNgay(BuildContext context) async {
    final today = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(today.year, today.month, today.day), 
      lastDate: today.add(const Duration(days: 365)), 
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> times = [
      {"time": "7:00 AM", "session": "Sáng"},
      {"time": "7:30 AM", "session": "Sáng"},
      {"time": "1:00 PM", "session": "Chiều"},
      {"time": "2:00 PM", "session": "Chiều"},
    ];

      Widget _buildCheckIcon({double size = 20, Color color = Colors.green, EdgeInsetsGeometry? margin}) {
    return Container(
    margin: margin ?? const EdgeInsets.only(right: 8),
    child: Icon(Icons.check_circle, color: color, size: size),
  );
  }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Xác nhận lịch hẹn",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0165FC),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
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
            const Text("Nguyễn Văn A", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            const Text(
              "Chuyên khoa:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text("Nội khoa", style: TextStyle(fontSize: 16)),
            const Divider(height: 30),

            const Text(
              "Chọn ngày khám:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _chonNgay(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.black), // viền đen
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Transform.translate(
                      offset: const Offset(6, 1),
                      child: const Icon(Icons.calendar_today, size: 20),
                    ),
                    Text(
                      _selectedDate != null
                          ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                          : "Chọn ngày",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: _selectedDate != null ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (_selectedDate != null)
                      _buildCheckIcon(size: 24, color: Colors.green, margin: EdgeInsets.only(right: 12))
                    else
                      const SizedBox(width: 20), 
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Chọn giờ:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: times.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedTime == times[index]["time"];
                  Color backgroundColor =
                      times[index]["session"] == "Sáng"
                          ? Colors.green
                          : Colors.orange;
                  return GestureDetector(
                    onTap:
                        () => setState(
                          () =>
                              _selectedTime =
                                  isSelected ? null : times[index]["time"],
                        ),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFF0165FC)
                                : backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        times[index]["time"],
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

            const Text(
              "Bảo hiểm y tế:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Checkbox(
                  value: _hasInsurance,
                  onChanged: (value) => setState(() => _hasInsurance = value!),
                ),
                const Text("Có bảo hiểm"),
                const SizedBox(width: 16),
                Checkbox(
                  value: !_hasInsurance,
                  onChanged: (value) => setState(() => _hasInsurance = !value!),
                ),
                const Text("Không có bảo hiểm"),
              ],
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const DanhSachLichChuaThanhToanScreen(),
                    ),
                  );
                },
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
