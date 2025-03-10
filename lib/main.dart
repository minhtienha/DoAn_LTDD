import 'package:flutter/material.dart';
import 'package:baicode/bai1.dart';
import 'package:baicode/baitaptailop01.dart';
import 'package:baicode/trangchu.dart';
import 'package:baicode/baitap02tailop.dart';
import 'package:baicode/trangdatlichtheobacsi.dart';
import 'package:baicode/trangphieukham.dart';
import 'package:baicode/trangthongtin.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const trangchu(),
    );
  }
}