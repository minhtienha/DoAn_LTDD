import 'package:flutter/material.dart';
import 't_DanhSachLichChon.dart';

class ChonChuyenKhoaScreen extends StatefulWidget {
  const ChonChuyenKhoaScreen({super.key});

  @override
  State<ChonChuyenKhoaScreen> createState() => _ChonChuyenKhoaScreenState();
}

class _ChonChuyenKhoaScreenState extends State<ChonChuyenKhoaScreen> {
  String? _selectedSpecialty;
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _selectedDoctor;
  bool _hasInsurance = false;

  final List<String> chuyenKhoaList = [
    "Nội khoa",
    "Nhi khoa",
    "Tim mạch",
    "Da liễu",
    "Xương khớp",
  ];
  final List<Map<String, dynamic>> times = [
    {"time": "7:00 AM", "session": "Sáng"},
    {"time": "7:30 AM", "session": "Sáng"},
    {"time": "1:00 PM", "session": "Chiều"},
    {"time": "2:00 PM", "session": "Chiều"},
  ];
  final List<Map<String, String>> doctors = [
    {"name": "BS. Nguyễn Văn A", "specialty": "Nội khoa"},
    {"name": "BS. Trần Văn B", "specialty": "Tim mạch"},
    {"name": "BS. Lê Thị C", "specialty": "Da liễu"},
  ];

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

  Widget _buildCheckIcon({double size = 20, Color color = Colors.green, EdgeInsetsGeometry? margin}) {
  return Container(
    margin: margin ?? const EdgeInsets.only(right: 8),
    child: Icon(Icons.check_circle, color: color, size: size),
  );
 }

  void _showSpecialtyPopup(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Chọn chuyên khoa"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: chuyenKhoaList.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedSpecialty == chuyenKhoaList[index];
                  return ListTile(
                    title: Text(
                      chuyenKhoaList[index],
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blueAccent : Colors.black,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedSpecialty = chuyenKhoaList[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy"),
              ),
            ],
          ),
    );
  }

  void _showDoctorPopup(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Chọn bác sĩ"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedDoctor == doctors[index]["name"];
                  return ListTile(
                    title: Text(
                      doctors[index]["name"]!,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blueAccent : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      "Chuyên khoa: ${doctors[index]["specialty"]}",
                    ),
                    onTap: () {
                      setState(() {
                        _selectedDoctor = doctors[index]["name"];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chọn chuyên khoa",
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
              "Chọn chuyên khoa:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showSpecialtyPopup(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.black),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  children: [
                    Transform.translate(
                      offset: const Offset(6, 1),
                      child: const Icon(Icons.local_hospital, size: 22),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          _selectedSpecialty ?? "Chọn chuyên khoa",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: _selectedSpecialty != null ? FontWeight.bold : FontWeight.normal,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    if (_selectedSpecialty != null)
                      _buildCheckIcon(size: 24, color: Colors.green, margin: EdgeInsets.only(right: 12))
                    else
                      const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

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
              "Chọn giờ khám:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
              "Chọn bác sĩ:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showDoctorPopup(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.black),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  children: [
                    // Icon bác sĩ bên trái
                    Transform.translate(
                      offset: const Offset(6, 1),
                      child: const Icon(Icons.person, size: 22),
                    ),

                    const SizedBox(width: 8),

                    // Text nằm giữa bằng Expanded + Align
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          _selectedDoctor ?? "Chọn bác sĩ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: _selectedDoctor != null ? FontWeight.bold : FontWeight.normal,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),

                    // Tick xanh bên phải nếu đã chọn
                    if (_selectedDoctor != null)
                      _buildCheckIcon(size: 24, color: Colors.green, margin: EdgeInsets.only(right: 12))
                    else
                      const SizedBox(width: 20), // giữ khoảng trống để tránh lệch
                  ],
                ),
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
