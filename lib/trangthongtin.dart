import 'package:flutter/material.dart';

class trangdatlichtheophong extends StatelessWidget {
  const trangdatlichtheophong({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(appBar: AppBar(
        title: const Text(
          "Thông tin Nhóm",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text(
                "Mã nhóm: G12345",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tên nhóm: Nhóm nghiên cứu A",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              const Text(
                "Số lượng thành viên: 3",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                "Thành viên:",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const MemberInfo(
                studentId: "SV001",
                studentName: "Nguyễn Văn A",
                role: "Nhóm trưởng",
              ),
              const SizedBox(height: 10),
              const MemberInfo(
                studentId: "SV002",
                studentName: "Trần Thị B",
                role: "Thành viên",
              ),
              const SizedBox(height: 10),
              const MemberInfo(
                studentId: "SV003",
                studentName: "Lê Văn C",
                role: "Thành viên",
              ),
            ],
          ),
        ),),

    );
  }
}

class MemberInfo extends StatelessWidget {
  final String studentId;
  final String studentName;
  final String role;

  const MemberInfo({
    Key? key,
    required this.studentId,
    required this.studentName,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mã sinh viên: $studentId",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              "Tên sinh viên: $studentName",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              "Vai trò: $role",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}