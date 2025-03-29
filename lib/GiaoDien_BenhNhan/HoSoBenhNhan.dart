import 'package:flutter/material.dart';
import 'TaoMoiHoSoBenhNhan.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0165FC),
        elevation: 0,
        title: const Text(
          'Hồ sơ bệnh nhân',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Xử lý sự kiện khi nhấn nút quay lại
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // Chuyển đến màn hình tạo mới hồ sơ
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateProfileScreen(),
                ),
              );
            },
            icon: const Icon(Icons.person_add_alt, color: Colors.white),
            label: const Text('Tạo mới', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Thông báo khi chưa có hồ sơ
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Bạn chưa có hồ sơ bệnh nhân. Vui lòng tạo mới hồ sơ để được đặt khám.',
                    style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
          ),

          // Phần chính của màn hình
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Tiêu đề
                  const Center(
                    child: Text(
                      'Tạo hồ sơ bệnh nhân',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Mô tả
                  const Center(
                    child: Text(
                      'Bạn được phép tạo tối đa 10 hồ sơ (cá nhân và người thân trong gia đình)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nút "Chưa từng khám đăng ký mới"
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Chuyển đến màn hình tạo mới hồ sơ
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateProfileScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0165FC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'CHƯA TỪNG KHÁM ĐĂNG KÝ MỚI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
