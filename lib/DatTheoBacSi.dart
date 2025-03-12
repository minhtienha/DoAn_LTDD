import 'package:flutter/material.dart';
import 'package:doan_nhom06/ThongTinBacSi.dart';

class DatTheoBacSi extends StatelessWidget {
  const DatTheoBacSi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chọn bác sĩ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: Icon(Icons.arrow_back, color: Colors.white),
        backgroundColor: Color(0xFF0165FC),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 45,
              width: 360,
              child: TextField(
                style: TextStyle(
                  color: Color(0xff020202),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffeaecf0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Tìm nhanh tên bác sĩ",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 118, 117, 117),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                    decorationThickness: 6,
                  ),
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Container "Chuyên khoa"
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 35,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xff0165fc),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Chuyên khoa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),

                // Container "Giới tính"
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 35,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xff0165fc),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Giới tính',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 26, top: 20),
            child: Text(
              'Danh sách bác sĩ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hàng chứa ảnh bác sĩ và thông tin
                          Row(
                            children: [
                              // Ảnh bác sĩ
                              Container(
                                height: 120,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xff484848),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/bs1.jpg'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              // Thông tin bác sĩ
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bác sĩ Nguyễn Văn A',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Chuyên khoa: Nội khoa',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff484848),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Giới tính: Nam',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff484848),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 30,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Color(0xff0165fc),
                                      ),
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ThongTinBacSi(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Xem thông tin',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 40,
                            width: double.infinity, // Chiếm toàn bộ chiều ngang
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xff0165fc),
                            ),
                            child: Center(
                              child: Text(
                                'Đặt lịch',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hàng chứa ảnh bác sĩ và thông tin
                          Row(
                            children: [
                              // Ảnh bác sĩ
                              Container(
                                height: 120,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xff484848),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/bs1.jpg'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              // Thông tin bác sĩ
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bác sĩ Nguyễn Văn A',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Chuyên khoa: Nội khoa',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff484848),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Giới tính: Nam',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff484848),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 30,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Color(0xff0165fc),
                                      ),
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ThongTinBacSi(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Xem thông tin',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 40,
                            width: double.infinity, // Chiếm toàn bộ chiều ngang
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xff0165fc),
                            ),
                            child: Center(
                              child: Text(
                                'Đặt lịch',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hàng chứa ảnh bác sĩ và thông tin
                          Row(
                            children: [
                              // Ảnh bác sĩ
                              Container(
                                height: 120,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xff484848),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/bs1.jpg'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              // Thông tin bác sĩ
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bác sĩ Nguyễn Văn A',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Chuyên khoa: Nội khoa',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff484848),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Giới tính: Nam',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff484848),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 30,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Color(0xff0165fc),
                                      ),
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ThongTinBacSi(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Xem thông tin',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ), // Khoảng cách giữa thông tin và nút
                          // Nút Đặt lịch (Bên dưới ảnh và thông tin)
                          Container(
                            height: 40,
                            width: double.infinity, // Chiếm toàn bộ chiều ngang
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xff0165fc),
                            ),
                            child: Center(
                              child: Text(
                                'Đặt lịch',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hàng chứa ảnh bác sĩ và thông tin
                          Row(
                            children: [
                              // Ảnh bác sĩ
                              Container(
                                height: 120,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xff484848),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/bs1.jpg'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              // Thông tin bác sĩ
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bác sĩ Nguyễn Văn A',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Chuyên khoa: Nội khoa',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff484848),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Giới tính: Nam',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff484848),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 30,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Color(0xff0165fc),
                                      ),
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ThongTinBacSi(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Xem thông tin',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ), // Khoảng cách giữa thông tin và nút
                          // Nút Đặt lịch (Bên dưới ảnh và thông tin)
                          Container(
                            height: 40,
                            width: double.infinity, // Chiếm toàn bộ chiều ngang
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xff0165fc),
                            ),
                            child: Center(
                              child: Text(
                                'Đặt lịch',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
