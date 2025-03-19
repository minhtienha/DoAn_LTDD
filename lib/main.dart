import 'package:doan_nhom06/trangChu.dart';
import 'package:doan_nhom06/trangDangKy.dart';
import 'package:doan_nhom06/trangdangnhap.dart';
import 'package:flutter/material.dart';

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
      home: const DangNhap(),
    );
  }
}
