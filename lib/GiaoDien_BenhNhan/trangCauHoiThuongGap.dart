import 'package:flutter/material.dart';

class CauHoi extends StatefulWidget {
  const CauHoi({super.key});

  @override
  _MedicalRecordScreenState createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<CauHoi> {
  // Trạng thái cho các câu hỏi có/không (4 câu hỏi, mặc định là false)
  List<bool> answers = List.filled(4, false);

  // Danh sách câu hỏi
  final List<String> questions = [
    'Lỗi ích sử dụng ứng dụng đăng ký khám bệnh trực tuyến ngay lập tức?',
    'Làm sao để sử dụng ứng dụng đăng ký khám bệnh trực tuyến?',
    'Đăng ký khám bệnh online có mất phí không?',
    'Tôi có thể dùng ứng dụng đăng ký tại các cơ sở y tế khác không?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh điều hướng trên cùng
      appBar: AppBar(
        backgroundColor: Color(0xFF0165FC),
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back,
              color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Một số câu hỏi thường gặp",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Xử lý sự kiện khi nhấn nút menu (có thể để trống hoặc thêm logic)
            },
          ),
        ],
      ),
      // Nội dung chính
      body: Column(
        children: [
          // Phần 1: Danh sách hỗ trợ có thể mở rộng
          ExpansionTile(
            title: const Text('Giải đáp nhận cứu hộ'),
            collapsedBackgroundColor: Colors.blue,
            backgroundColor: Colors.white,
            collapsedTextColor: Colors.white,
            textColor: Colors.black,
            children: [
              ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.blue),
                title: const Text('Vấn đề chung'),
              ),
              ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.blue),
                title: const Text('Vấn đề tài khoản'),
              ),
              ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.blue),
                title: const Text('Vấn đề về quy trình đặt khám'),
              ),
              ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.blue),
                title: const Text('Vấn đề về thanh toán'),
              ),
              ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.blue),
                title: const Text('Vấn đề trả sau qua Fundiin'),
              ),
            ],
          ),
          // Phần 2: Danh sách câu hỏi có/không
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(questions[index]),
                  trailing: Switch(
                    value: answers[index],
                    onChanged: (value) {
                      setState(() {
                        answers[index] = value;
                      });
                    },
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

