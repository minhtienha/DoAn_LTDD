import 'package:doan_nhom06/GiaoDien_BenhNhan/XacNhanDatBacSi.dart';
import 'package:flutter/material.dart';

class DatBacSi extends StatefulWidget {
  const DatBacSi({super.key});

  @override
  _DatBacSiState createState() => _DatBacSiState();
}

class _DatBacSiState extends State<DatBacSi> {
  String? selectedDate;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    //
    List<Map<String, String>> dates = [
      {'day': 'Thứ 2', 'date': '10/03'},
      {'day': 'Thứ 3', 'date': '11/03'},
      {'day': 'Thứ 4', 'date': '12/03'},
      {'day': 'Thứ 5', 'date': '13/03'},
      {'day': 'Thứ 6', 'date': '14/03'},
    ];

    List<String> times = ['7:00 AM', '7:30 AM', '8:00 AM', '8:30 AM'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đặt lịch hẹn với bác sĩ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Color(0xFF0165FC),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                padding: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(255, 51, 119, 255),
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/bs1.jpg'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BS. Trần Văn A',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Chuyên khoa: Nội khoa, Tiêu hóa',
                          style: TextStyle(
                            color: Color(0xff484848),
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chọn ngày:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          dates.map((date) {
                            bool isSelected = selectedDate == date['date'];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDate =
                                      isSelected ? null : date['date'];
                                });
                              },
                              child: Container(
                                width: 100,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Color(0xFF0165FC)
                                          : Colors.white,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Color(0xFF0165FC)
                                            : Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      date['day']!,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      date['date']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chọn giờ hẹn:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          times.map((time) {
                            bool isSelected = selectedTime == time;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTime = isSelected ? null : time;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Color(0xFF0165FC)
                                          : Colors.white,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Color(0xFF0165FC)
                                            : Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => XacNhanDatBacSi(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0165FC),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Xác nhận đặt lịch'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
