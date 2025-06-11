import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class QuanLyLichKham extends StatefulWidget {
  const QuanLyLichKham({super.key});

  @override
  State<QuanLyLichKham> createState() => _QuanLyLichKhamState();
}

class _QuanLyLichKhamState extends State<QuanLyLichKham> {
  bool loading = true;
  List<dynamic> lichKhamList = [];

  @override
  void initState() {
    super.initState();
    fetchLichKham();
  }

  Future<void> fetchLichKham() async {
    setState(() {
      loading = true;
    });
    try {
      final resp = await http.get(Uri.parse('${getBaseUrl()}api/LichKham'));
      if (resp.statusCode == 200) {
        setState(() {
          lichKhamList = jsonDecode(resp.body) as List;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Lấy lịch khám thất bại!'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lỗi kết nối API'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String formatDateTime(String datetime) {
    try {
      final dt = DateTime.parse(datetime);
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year} "
          "${dt.hour.toString().padLeft(2, '0')}:"
          "${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return datetime;
    }
  }

  Color getTrangThaiColor(String trangThai) {
    switch (trangThai.toLowerCase()) {
      case 'đã khám':
      case 'hoàn thành':
        return Colors.green;
      case 'đang khám':
      case 'đang chờ':
        return Colors.orange;
      case 'hủy':
      case 'không đến':
        return Colors.red;
      case 'đã thanh toán':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getTrangThaiIcon(String trangThai) {
    switch (trangThai.toLowerCase()) {
      case 'đã khám':
      case 'hoàn thành':
        return Icons.check_circle;
      case 'đang khám':
      case 'đang chờ':
        return Icons.schedule;
      case 'hủy':
      case 'không đến':
        return Icons.cancel;
      case 'đã thanh toán':
        return Icons.payment;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Quản lý Lịch khám',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF0165FC),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchLichKham,
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ), // đổi iconTheme thành trắng
      ),
      body:
          loading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Đang tải dữ liệu...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
              : lichKhamList.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Không có lịch khám nào',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hãy thêm lịch khám mới',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: fetchLichKham,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lichKhamList.length,
                  itemBuilder: (context, index) {
                    final item = lichKhamList[index];
                    final bacSiName =
                        item['bacSi']?['hoVaTen'] ?? 'Chưa có bác sĩ';
                    final benhNhanName =
                        item['hoSoBenhNhan']?['hoVaTen'] ?? 'Chưa có bệnh nhân';
                    final thoiGianKham = item['thoiGianKham'] ?? '';
                    final trangThaiKham =
                        item['trangThaiKham'] ?? 'Chưa rõ trạng thái';
                    final trangThaiTT =
                        item['trangThaiTT'] ?? 'Chưa rõ trạng thái';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header với thời gian
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Colors.blue[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        formatDateTime(thoiGianKham),
                                        style: TextStyle(
                                          color: Colors.blue[600],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Thông tin bác sĩ
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.local_hospital,
                                    color: Colors.green[600],
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Bác sĩ khám',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        bacSiName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Thông tin bệnh nhân
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.orange[600],
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Bệnh nhân',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        benhNhanName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Trạng thái
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getTrangThaiColor(
                                        trangThaiKham,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: getTrangThaiColor(
                                          trangThaiKham,
                                        ).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          getTrangThaiIcon(trangThaiKham),
                                          size: 16,
                                          color: getTrangThaiColor(
                                            trangThaiKham,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            trangThaiKham,
                                            style: TextStyle(
                                              color: getTrangThaiColor(
                                                trangThaiKham,
                                              ),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getTrangThaiColor(
                                        trangThaiTT,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: getTrangThaiColor(
                                          trangThaiTT,
                                        ).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          getTrangThaiIcon(trangThaiTT),
                                          size: 16,
                                          color: getTrangThaiColor(trangThaiTT),
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            trangThaiTT,
                                            style: TextStyle(
                                              color: getTrangThaiColor(
                                                trangThaiTT,
                                              ),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
