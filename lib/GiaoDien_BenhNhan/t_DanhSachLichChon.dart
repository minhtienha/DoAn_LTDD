import 'package:doan_nhom06/GiaoDien_BenhNhan/t_ChonBacSiKham.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_DatLichKhamChuyenKhoa.dart';
import 'package:doan_nhom06/GiaoDien_BenhNhan/t_TrangChuBenhNhan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class DanhSachLichChuaThanhToanScreen extends StatefulWidget {
  final Map<String, dynamic> hoSo;
  final int userId;
  final DateTime? ngayChon;
  final List<Map<String, dynamic>> selectedBookings;
  const DanhSachLichChuaThanhToanScreen({
    super.key,
    required this.hoSo,
    required this.userId,
    required this.ngayChon,
    required this.selectedBookings,
  });

  @override
  State<DanhSachLichChuaThanhToanScreen> createState() =>
      _DanhSachLichChuaThanhToanScreenState();
}

class _DanhSachLichChuaThanhToanScreenState
    extends State<DanhSachLichChuaThanhToanScreen> {
  final baseUrl = "${getBaseUrl()}api";

  Future<void> guiNhieuLichKhamVaThanhToan(
    List<Map<String, dynamic>> bookings,
  ) async {
    // 1. Tính tổng tiền
    final tongTien = bookings.fold(
      0,
      (sum, item) => sum + (item["gia"] as num).toInt(),
    );

    // 2. Tạo thanh toán 1 lần
    final thanhToanResp = await http.post(
      Uri.parse("$baseUrl/ThanhToan"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "soTien": tongTien,
        "soTienHoan": 0,
        "trangThai": "Đã thanh toán",
        "ngayTao": DateTime.now().toIso8601String(),
      }),
    );

    if (thanhToanResp.statusCode != 201) {
      print("Lỗi khi gửi thanh toán: ${thanhToanResp.statusCode}");
      print("Nội dung lỗi từ server: ${thanhToanResp.body}");
      return;
    }

    final thanhToanData = jsonDecode(thanhToanResp.body);
    final int maThanhToan = thanhToanData["maThanhToan"];
    print("Thanh toán tạo thành công: $maThanhToan");

    // 3. Lặp qua từng booking, tạo lịch khám và liên kết với mã thanh toán
    for (var bookingData in bookings) {
      try {
        final bacSiId = bookingData["bacSiId"];
        if (bacSiId == null) continue;

        // Tạo lịch khám
        final lichKhamResp = await http.post(
          Uri.parse("$baseUrl/LichKham"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "maHoSoBenhNhan": bookingData["hoSoId"],
            "maBacSi": bookingData["bacSiId"],
            "thoiGianKham": _formatDateTime(
              bookingData["ngayKham"],
              bookingData["khungGio"],
            ),
            "gia": (bookingData["gia"] as num).toDouble(),
            "trangThaiTT": "Đã thanh toán",
            "trangThaiKham": "Chưa khám",
            "ngayTao": DateTime.now().toIso8601String(),
          }),
        );
        print(
          "Gửi giá trị giá: ${bookingData["gia"]} (${bookingData["gia"].runtimeType})",
        );
        if (lichKhamResp.statusCode != 201) {
          print("Lỗi khi gửi lịch khám: ${lichKhamResp.statusCode}");
          print("Nội dung lỗi từ server: ${lichKhamResp.body}");
          continue;
        }

        final lichKhamData = jsonDecode(lichKhamResp.body);
        final int maLichKham = lichKhamData["maLichKham"];
        print("Lịch khám tạo thành công: $maLichKham");

        // Liên kết lịch khám với thanh toán
        final lkResp = await http.post(
          Uri.parse("$baseUrl/LichKham_ThanhToan"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "maLichKham": maLichKham,
            "maThanhToan": maThanhToan,
          }),
        );

        if (lkResp.statusCode != 201) {
          print("Lỗi liên kết lịch khám - thanh toán: ${lkResp.statusCode}");
        } else {
          print("Liên kết lịch khám - thanh toán thành công!");
        }

        // Gửi thông báo cho bác sĩ về lịch khám mới
        await http.post(
          Uri.parse("$baseUrl/ThongBao"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "maNguoiNhan": bookingData["bacSiId"],
            "noiDung":
                "Bạn có lịch khám mới từ bệnh nhân vào ngày ${bookingData["ngayKham"]} lúc ${bookingData["khungGio"]}.",
            "trangThaiDoc": false,
            "ngayTao": DateTime.now().toIso8601String(),
          }),
        );
      } catch (e) {
        print("Lỗi khi gửi booking: $e");
      }
    }
  }

  String _formatDateTime(String ngayKham, String khungGio) {
    final parts = ngayKham.split("/");
    if (parts.length != 3) return "";

    final day = parts[0].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];

    final gioParts = khungGio.split("-");
    final startTime = gioParts[0].trim();

    // Trả về chuẩn ISO 8601: yyyy-MM-ddTHH:mm:ss
    return "$year-$month-$day"
        "T"
        "$startTime:00";
  }

  void _thanhToan() async {
    if (widget.selectedBookings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Danh sách lịch đặt trống!")),
      );
      return;
    }

    // Gửi dữ liệu lên server
    await guiNhieuLichKhamVaThanhToan(widget.selectedBookings);

    // Hiển thị snackbar khi thanh toán thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Thanh toán thành công!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Sau khi gửi thành công, có thể chuyển sang trang thanh toán hoặc hiển thị thông báo
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrangChu(userId: widget.userId)),
    );
  }

  int get tongTien {
    return widget.selectedBookings.fold(
      0,
      (sum, item) => sum + (item["gia"] as num).toInt(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thông tin đặt khám",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0165FC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text("Xác nhận"),
                    content: const Text(
                      "Bạn có chắc chắn muốn quay lại? Danh sách lịch hiện tại sẽ bị huỷ.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Không"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Có"),
                      ),
                    ],
                  ),
            );
            if (shouldPop == true) {
              widget.selectedBookings.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => TrangChu(userId: widget.userId),
                ),
                (route) => false,
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                widget.selectedBookings.isEmpty
                    ? const Center(
                      child: Text(
                        "Danh sách lịch đặt trống!",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.selectedBookings.length,
                      itemBuilder: (context, index) {
                        final lich = widget.selectedBookings[index];

                        int hour = int.parse(lich["khungGio"].split(":")[0]);
                        Color sessionColor =
                            (hour < 12) ? Colors.green : Colors.orange;
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Dòng này: Tên bác sĩ + nút xoá
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      lich["bacSiTen"],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      tooltip: "Xoá lịch này",
                                      onPressed: () {
                                        setState(() {
                                          widget.selectedBookings.removeAt(
                                            index,
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 8,
                                ), // 🔹 Khoảng cách giữa các thành phần
                                // 🔥 Chuyên khoa & Giá (Căn lề hai bên)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Chuyên khoa: ${lich["chuyenKhoa"]}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "${lich["gia"]} đ",
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8), // 🔹 Tạo khoảng cách
                                // 📅 Ngày khám
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Ngày khám: ${lich["ngayKham"]}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 8,
                                ), // 🔹 Khoảng cách giữa các thành phần
                                // ⏰ Giờ khám (Tạo badge đẹp hơn)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Giờ khám: ${lich["khungGio"]}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
          // Thêm tổng tiền ở đây
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Tổng tiền: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$tongTien đ",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final option = await showDialog<String>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text("Chọn cách thêm lịch"),
                            content: const Text(
                              "Bạn muốn thêm lịch theo chuyên khoa hay theo bác sĩ?",
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () =>
                                        Navigator.of(context).pop("chuyenkhoa"),
                                child: const Text("Thêm chuyên khoa"),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop("bacsi"),
                                child: const Text("Thêm bác sĩ"),
                              ),
                            ],
                          ),
                    );
                    if (option == "chuyenkhoa") {
                      // Điều hướng sang màn hình thêm chuyên khoa
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChonChuyenKhoaScreen(
                                hoSo: widget.hoSo,
                                userId: widget.userId,
                                selectedBookings:
                                    List<Map<String, dynamic>>.from(
                                      widget.selectedBookings,
                                    ), // truyền vào đây
                              ),
                        ),
                      );
                    } else if (option == "bacsi") {
                      // Điều hướng sang màn hình chọn bác sĩ (ví dụ: ChonBacSiScreen)
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChonBacSiScreen(
                                hoSo: widget.hoSo,
                                userId: widget.userId,
                                selectedBookings:
                                    List<Map<String, dynamic>>.from(
                                      widget.selectedBookings,
                                    ), // truyền vào đây
                              ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Thêm chuyên khoa",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _thanhToan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  icon: const Icon(Icons.payment, color: Colors.white),
                  label: const Text(
                    "Thanh toán",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
