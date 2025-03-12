import 'package:doan_nhom06/DatThanhCong.dart';
import 'package:doan_nhom06/XacNhanDatBacSi.dart';
import 'package:flutter/material.dart';
import 'package:doan_nhom06/DatBacSi.dart';
import 'package:doan_nhom06/DatTheoBacSi.dart';
import 'package:doan_nhom06/ThongTinBacSi.dart';
import 'package:doan_nhom06/trangchu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng demo Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DatTheoBacSi(),
    );
  }
}
