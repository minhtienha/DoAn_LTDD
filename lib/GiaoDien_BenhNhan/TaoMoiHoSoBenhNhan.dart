import 'package:flutter/material.dart';

class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0165FC),
        centerTitle: true,
        title: const Text(
          'Tạo mới hồ sơ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Quay trở về màn hình trước
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),

            buildFormField(
              label: 'Họ và tên',
              hintText: 'Nhập họ và tên',
              icon: Icons.person,
              isRequired: true,
            ),

            const SizedBox(height: 16),
            buildFormField(
              label: 'Ngày sinh',
              hintText: 'DD/MM/YYYY',
              icon: Icons.calendar_today,
              isRequired: true,
            ),

            const SizedBox(height: 16),
            buildFormField(
              label: 'Giới tính',
              hintText: 'Chọn giới tính',
              icon: Icons.person_outline,
              isRequired: true,
              isDropdown: true,
            ),
            const SizedBox(height: 16),
            buildFormField(
              label: 'Số CCCD/Mã định danh',
              hintText: 'Nhập số CCCD/Mã định danh',
              icon: Icons.credit_card,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            buildFormField(
              label: 'Mã bảo hiểm y tế (nếu có)',
              hintText: 'Mã bảo hiểm y tế',
              icon: Icons.medical_information,
              isRequired: false,
            ),
            const SizedBox(height: 16),
            buildFormField(
              label: 'Số điện thoại',
              hintText: 'Nhập số điện thoại',
              icon: Icons.phone,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            buildFormField(
              label: 'Email (Dùng để nhận phiếu khám)',
              hintText: 'Nhập email',
              icon: Icons.email,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            buildFormField(
              label: 'Địa chỉ(ghi trên CCCD)',
              hintText: 'Nhập địa chỉ',
              icon: Icons.home,
              isRequired: true,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Chỉ quay trở về màn hình trước
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0165FC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'LƯU HỒ SƠ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget xây dựng trường nhập liệu giả
  Widget buildFormField({
    required String label,
    required String hintText,
    required IconData icon,
    required bool isRequired,
    bool isDropdown = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Icon(icon, color: Color(0xFF0165FC)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hintText,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                ),
              ),
              if (isDropdown)
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
