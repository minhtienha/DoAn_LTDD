import 'package:flutter/material.dart';
import 'package:doan_nhom06/trangdatlichphongkham.dart';

class ClinicListPage extends StatefulWidget {
  @override
  _ClinicListPageState createState() => _ClinicListPageState();
}

class _ClinicListPageState extends State<ClinicListPage> {
  final List<Map<String, String>> clinics = [
    {
      'name': 'Phòng Khám Đa Khoa Pháp Anh',
      'address': '222-224-226 Nguyễn Duy Dương, Quận 10, TP.HCM',
      'rating': '4.7',
    },
    {
      'name': 'Phòng Khám Quận 10',
      'address': 'Hado Centrosa Garden, Quận 10, TP.HCM',
      'rating': '4.0',
    },
    {
      'name': 'Phòng Khám Đa Khoa Hải Phòng',
      'address': '33 Kỳ Đồng, Hải Phòng',
      'rating': '0',
    },
    {
      'name': 'Phòng Khám quận Tân Phú',
      'address': '100 Lê Trọng Tân, Tân Phú, TP.HCM',
      'rating': '0',
    },
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn phòng khám',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: const Color.fromARGB(255, 66, 149, 217),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            },
          ),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm cơ sở y tế',
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: clinics.length,
              itemBuilder: (context, index) {
                final clinic = clinics[index];

                if (!clinic['name']!.toLowerCase().contains(searchQuery)) {
                  return Container();
                }

                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.network(
                              clinic['imageUrl'] ?? 'https://img.freepik.com/free-vector/people-walking-sitting-hospital-building-city-clinic-glass-exterior-flat-vector-illustration-medical-help-emergency-architecture-healthcare-concept_74855-10130.jpg',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    clinic['name']!,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  SizedBox(height: 8),
                                  Text(clinic['address']!, 
                                  style: TextStyle(fontSize: 15),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        color: Colors.lightBlue.shade100,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.blue),
                                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Xem chi tiết',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),

                            SizedBox(width: 12),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                     builder: (context) => BookingPage(
                                      clinic: clinic
                                      ),
                                   ),
                                 );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Đặt khám ngay', style: TextStyle(fontSize: 16,color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}