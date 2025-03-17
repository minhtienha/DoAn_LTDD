import 'package:flutter/material.dart';

class ConfirmBookingPage extends StatelessWidget {
  final String name;
  final String phone;
  final String birthDate;
  final String gender;
  final String city;
  final String specialty;
  final String service;
  final String date;
  final String time;
  final Map<String, String> clinic;

  const ConfirmBookingPage({Key? key,
    required this.name,
    required this.phone,
    required this.birthDate,
    required this.gender,
    required this.city,
    required this.clinic,
    required this.specialty, required this.service, required this.date, required this.time
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận thông tin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 66, 149, 217),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(clinic['name'] ?? 'Không có tên phòng khám',
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(clinic['address'] ?? 'Không có địa chỉ', style: const TextStyle(fontSize: 15, color: Color.fromARGB(255, 0, 0, 0))),
                  const Divider(),
                  const SizedBox(height: 8),

                  const Text('Thông tin bệnh nhân', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person, 'Họ và tên:', name),
                  _buildInfoRow(Icons.phone, 'Số điện thoại:', phone),
                  _buildInfoRow(Icons.cake, 'Ngày sinh:', birthDate),
                  _buildInfoRow(Icons.male, 'Giới tính:', gender),
                  _buildInfoRow(Icons.location_city, 'Thành phố:', city),
                  
                  const Divider(),

                  const Text('Thông tin đặt khám', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.local_hospital, 'Chuyên khoa:', specialty),
                  _buildInfoRow(Icons.medical_services, 'Dịch vụ:', service),
                  _buildInfoRow(Icons.calendar_today, 'Ngày khám:', date),
                  _buildInfoRow(Icons.lock_clock, 'Thời gian:', time),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.red.shade100,
              child: const Text(
                '⚠️ Vui lòng kiểm tra kĩ lại các thông tin bạn đã nhập để đảm bảo không xảy ra lỗi.',
                style: TextStyle(color: Colors.red),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Tiền khám:', style: TextStyle(fontSize: 18)),
                      Text('150 000 VNĐ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Tạm tính:', style: TextStyle(fontSize: 18, color: Colors.blue)),
                      Text('150 000 VNĐ', style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đặt khám thành công!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 66, 149, 217),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Xác Nhận Đặt Khám', style: TextStyle(color: Colors.white, fontSize: 18)),
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

  Widget _buildInfoRow(IconData icon, String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize:16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(content, style: const TextStyle(fontSize: 17)),
          ),
        ],
      ),
    );
  }
}
