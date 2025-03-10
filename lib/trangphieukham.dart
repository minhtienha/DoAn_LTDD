import 'package:flutter/material.dart';

class trangphieukham extends StatelessWidget {
  const trangphieukham({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Ngành học CNTT & ATTT",
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
                "1. Ngành Công nghệ Thông tin (CNTT)",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Ngành Công nghệ Thông tin (CNTT) là ngành học nghiên cứu về việc "
                    "thu thập, xử lý và truyền tải thông tin qua các phương tiện điện tử. "
                    "Sinh viên sẽ được trang bị kiến thức về lập trình, hệ thống thông tin, "
                    "quản trị mạng, và phát triển phần mềm.",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              const Text(
                "2. Ngành An toàn Thông tin (ATTT)",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Ngành An toàn Thông tin (ATTT) tập trung vào việc bảo mật thông tin, "
                    "chống lại các mối đe dọa từ bên ngoài và bên trong. Sinh viên sẽ "
                    "học về mã hóa, an ninh mạng, quản lý rủi ro, và các công nghệ bảo mật "
                    "để bảo vệ thông tin và hệ thống.",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              const Text(
                "Trường ĐH Công thương Thành phố Hồ Chí Minh cam kết cung cấp "
                    "chương trình đào tạo chất lượng cao, giúp sinh viên có kiến thức "
                    "vững chắc và kỹ năng thực hành để đáp ứng nhu cầu của thị trường.",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}