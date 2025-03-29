import 'package:flutter/material.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Lịch đặt của tôi',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF0165FC),
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 4.0, // Độ dày của gạch chân
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ), // Style chữ tab được chọn
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
            ), // Style chữ tab chưa chọn
            tabs: [Tab(text: 'Sắp tới')],
          ),
        ),

        body: TabBarView(
          children: [
            // Danh sách booking sắp tới
            ListView(
              padding: EdgeInsets.all(16.0),
              children: List.generate(3, (index) => BookingCard()),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  const BookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 216, 243, 255),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nguyễn Văn B',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('18-03-2025 - 10:00 AM'),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () {}, child: Text('Huỷ lịch')),
                ElevatedButton(onPressed: () {}, child: Text('Lên lịch lại')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
