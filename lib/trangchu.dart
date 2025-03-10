import 'package:flutter/material.dart';
import 'package:baicode/trangthongtin.dart';
import 'package:baicode/trangphieukham.dart';
import 'package:baicode/trangdatlichtheobacsi.dart';

class trangchu extends StatelessWidget {
  const trangchu({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 80, 135, 236),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  "assets/hinh/bong3.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Chào Minh Trí đến với Hospital 3T",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            // Sửa lỗi Expanded bị sai vị trí
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  // Đặt lịch phòng khám
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const trangdatlichtheophong(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            width: 120, // Chiều rộng cố định
                            height: 140, // Chiều cao cố định
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[50], // Nền xanh nhạt
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    "assets/hinh/iconlich.png",
                                    width: 60, // Kích thước lớn hơn một chút
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Đặt lịch theo phòng khám",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
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

                  //Phiếu khám
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const trangdatlichtheobacsi(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            width: 120, // Chiều rộng cố định
                            height: 140, // Chiều cao cố định
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[50], // Nền xanh nhạt
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    "assets/hinh/bacsi.png",
                                    width: 60, // Kích thước lớn hơn một chút
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Center(
                                  child:Text(
                                    textAlign: TextAlign.center,
                                    "Đặt lịch theo bác sĩ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
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

                  //Đặt lịch bác sĩ
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const trangphieukham(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            width: 120, // Chiều rộng cố định
                            height: 140, // Chiều cao cố định
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[50], // Nền xanh nhạt
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    "assets/hinh/hoadon.png",
                                    width: 60, // Kích thước lớn hơn một chút
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Center(
                                  child:Text(
                                    "Phiếu khám",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
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

                ],


              ),
            ),
          ],
        ),
      ),
    );
  }
}
