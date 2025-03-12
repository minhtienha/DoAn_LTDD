import 'package:flutter/material.dart';
import 'package:doan_nhom06/DatBacSi.dart';

class ThongTinBacSi extends StatelessWidget {
  const ThongTinBacSi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin bác sĩ',
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
                    'Giới thiệu:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'BS. Trần Văn A là bác sĩ chuyên khoa nội khoa, tiêu hóa tại Bệnh viện Đa khoa Hà Nội. Với hơn 10 năm kinh nghiệm, BS. A đã điều trị cho hàng nghìn bệnh nhân với nhiều bệnh lý khác nhau.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lịch làm việc:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thứ 2:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff484848),
                              ),
                            ),
                            Text(
                              'Thứ 3:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff484848),
                              ),
                            ),
                            Text(
                              'Thứ 4:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff484848),
                              ),
                            ),
                            Text(
                              'Thứ 5:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff484848),
                              ),
                            ),
                            Text(
                              'Thứ 6:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff484848),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '8:00 - 17:00',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '8:00 - 17:00',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '8:00 - 17:00',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '8:00 - 17:00',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '8:00 - 17:00',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
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
                        MaterialPageRoute(builder: (context) => DatBacSi()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0165FC),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Đặt lịch khám'),
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
