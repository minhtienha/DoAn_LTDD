import 'package:doan_nhom06/GiaoDien_BenhNhan/trangTaoHoSo.dart';
import 'package:flutter/material.dart';

class DatLichKhamBenh extends StatefulWidget {
  const DatLichKhamBenh({super.key});

  @override
  State<DatLichKhamBenh> createState() => _DatLichKhamBenhState();
}

class _DatLichKhamBenhState extends State<DatLichKhamBenh> {
  String? selectedSpecialty;
  String? selectedService;
  String? selectedDate;
  String? selectedTime;
  // String? selectedClinic;

  void _showBottomSheet(
    BuildContext context,
    String title,
    List<String> options,
    Function(String) onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            expand: false,
            builder:
                (_, scrollController) => ListView(
                  controller: scrollController,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(),
                    ...options.map(
                      (option) => ListTile(
                        title: Text(option),
                        onTap: () {
                          onSelect(option);
                          Navigator.pop(context);
                        },
                      ),
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
        title: Text(
          'Chọn thông tin khám',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0165FC),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            Text(
              'Chuyên khoa',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap:
                  () => _showBottomSheet(
                    context,
                    'Chọn chuyên khoa',
                    ['Tim mạch', 'Tai mũi họng', 'Da liễu', 'Nhi khoa'],
                    (value) {
                      setState(() => selectedSpecialty = value);
                    },
                  ),
              child: _buildOptionField(
                selectedSpecialty ?? 'Chọn chuyên khoa',
                Icons.local_hospital,
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Dịch vụ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap:
                  () => _showBottomSheet(
                    context,
                    'Chọn dịch vụ',
                    ['Khám tổng quát', 'Khám chuyên sâu', 'Xét nghiệm máu'],
                    (value) {
                      setState(() => selectedService = value);
                    },
                  ),
              child: _buildOptionField(
                selectedService ?? 'Chọn dịch vụ',
                Icons.medical_services,
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Ngày khám',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
              child: _buildOptionField(
                selectedDate ?? 'Chọn ngày khám',
                Icons.calendar_today,
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Giờ khám',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap:
                  () => _showBottomSheet(
                    context,
                    'Chọn khung giờ',
                    ['08:00', '09:00', '10:00', '11:00'],
                    (value) {
                      setState(() => selectedTime = value);
                    },
                  ),
              child: _buildOptionField(
                selectedTime ?? 'Chọn giờ',
                Icons.access_time,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (selectedSpecialty != null &&
                  selectedService != null &&
                  selectedDate != null &&
                  selectedTime != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PersonalInfoPage(
                          specialty: selectedSpecialty!,
                          service: selectedService!,
                          date: selectedDate!,
                          time: selectedTime!,
                          // clinic: selectedClinic!,
                        ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Vui lòng chọn đầy đủ thông tin'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0165FC),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Tiếp tục',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionField(String text, IconData icon) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 24),
              SizedBox(width: 10),
              Text(text, style: TextStyle(fontSize: 18, color: Colors.black87)),
            ],
          ),
          Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }
}
