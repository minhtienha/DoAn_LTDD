import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class XinNghiPhepPage extends StatefulWidget {
  final int maBacSi;
  const XinNghiPhepPage({super.key, required this.maBacSi});
  @override
  State<XinNghiPhepPage> createState() => _XinNghiPhepPageState();
}

class _XinNghiPhepPageState extends State<XinNghiPhepPage> {
  DateTime? ngayBatDau;
  DateTime? ngayKetThuc;
  TextEditingController ghiChuController = TextEditingController();
  bool isLoading = false;
  List<dynamic> donNghiList = [];
  bool loadingDonNghi = false;

  // Định dạng ngày
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    fetchDonNghiPhep();
  }

  Future<void> fetchDonNghiPhep() async {
    setState(() => loadingDonNghi = true);
    final url = '${getBaseUrl()}api/NghiPhepBacSi/BacSi/${widget.maBacSi}';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      setState(() => donNghiList = jsonDecode(resp.body));
    } else {
      setState(() => donNghiList = []);
    }
    setState(() => loadingDonNghi = false);
  }

  Future<void> submitNghiPhep() async {
    try {
      if (ngayBatDau == null || ngayKetThuc == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Vui lòng chọn ngày bắt đầu và kết thúc")),
        );
        return;
      }
      if (ngayBatDau!.isAfter(ngayKetThuc!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc"),
          ),
        );
        return;
      }

      // Kiểm tra trùng ngày
      for (var don in donNghiList) {
        DateTime donBatDau = DateTime.parse(don['ngayBatDau']);
        DateTime donKetThuc = DateTime.parse(don['ngayKetThuc']);
        if (!(ngayKetThuc!.isBefore(donBatDau) ||
            ngayBatDau!.isAfter(donKetThuc))) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Khoảng thời gian nghỉ phép trùng với đơn từ ${dateFormat.format(donBatDau)} đến ${dateFormat.format(donKetThuc)}",
              ),
            ),
          );
          return;
        }
      }

      setState(() => isLoading = true);

      final body = {
        "maBacSi": widget.maBacSi,
        "ngayBatDau": ngayBatDau!.toIso8601String(),
        "ngayKetThuc": ngayKetThuc!.toIso8601String(),
        "ghiChu": ghiChuController.text,
        "trangThai": "Chờ duyệt",
        "ngayTao": DateTime.now().toIso8601String(),
      };

      final url = '${getBaseUrl()}api/NghiPhepBacSi';
      final resp = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      setState(() => isLoading = false);

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gửi yêu cầu nghỉ phép thành công!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gửi yêu cầu thất bại, thử lại sau.")),
        );
      }
    } catch (error) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Có lỗi xảy ra: $error")));
    }
  }

  Future<void> pickDateStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: ngayBatDau ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF0165FC),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF0165FC)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        ngayBatDau = picked;
        // Reset ngayKetThuc if it's before ngayBatDau
        if (ngayKetThuc != null && ngayKetThuc!.isBefore(picked)) {
          ngayKetThuc = null;
        }
      });
    }
  }

  Future<void> pickDateEnd() async {
    // Ensure initialDate is on or after firstDate
    final firstDate = ngayBatDau ?? DateTime.now();
    final initialDate =
        ngayKetThuc != null && !ngayKetThuc!.isBefore(firstDate)
            ? ngayKetThuc!
            : firstDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF0165FC),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF0165FC)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => ngayKetThuc = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Xin Nghỉ Phép",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF0165FC),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Điền thông tin nghỉ phép",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0165FC),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildDatePicker(
                      label: "Ngày bắt đầu",
                      date: ngayBatDau,
                      onTap: pickDateStart,
                    ),
                    SizedBox(height: 16),
                    _buildDatePicker(
                      label: "Ngày kết thúc",
                      date: ngayKetThuc,
                      onTap: pickDateEnd,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Ghi chú (nếu có):",
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: ghiChuController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Nhập ghi chú về nghỉ phép...",
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : submitNghiPhep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0165FC),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Gửi yêu cầu nghỉ phép",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Danh sách đơn xin nghỉ phép",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0165FC),
              ),
            ),
            SizedBox(height: 12),
            loadingDonNghi
                ? Center(
                  child: CircularProgressIndicator(color: Color(0xFF0165FC)),
                )
                : donNghiList.isEmpty
                ? Center(
                  child: Text(
                    "Chưa có đơn nghỉ phép nào.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: donNghiList.length,
                  itemBuilder: (context, index) {
                    final don = donNghiList[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        title: Text(
                          "Từ ${dateFormat.format(DateTime.parse(don['ngayBatDau']))} đến ${dateFormat.format(DateTime.parse(don['ngayKetThuc']))}",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              "Trạng thái: ${don['trangThai']}",
                              style: TextStyle(
                                color:
                                    don['trangThai'] == "Chờ duyệt"
                                        ? Colors.orange
                                        : don['trangThai'] == "Đã duyệt"
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (don['ghiChu'] != null &&
                                don['ghiChu'].isNotEmpty)
                              Text("Ghi chú: ${don['ghiChu']}"),
                          ],
                        ),
                        trailing:
                            don['trangThai'] == "Chờ duyệt"
                                ? IconButton(
                                  icon: Icon(Icons.cancel, color: Colors.red),
                                  tooltip: "Hủy đơn",
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text("Xác nhận hủy đơn"),
                                            content: Text(
                                              "Bạn có chắc muốn hủy đơn nghỉ phép này?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.of(
                                                      context,
                                                    ).pop(false),
                                                child: Text(
                                                  "Không",
                                                  style: TextStyle(
                                                    color: Color(0xFF0165FC),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed:
                                                    () => Navigator.of(
                                                      context,
                                                    ).pop(true),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(
                                                    0xFF0165FC,
                                                  ),
                                                ),
                                                child: Text("Có"),
                                              ),
                                            ],
                                          ),
                                    );

                                    if (confirm != true) return;

                                    final url =
                                        '${getBaseUrl()}api/NghiPhepBacSi/${don['maNghiPhep']}';
                                    final resp = await http.delete(
                                      Uri.parse(url),
                                    );

                                    if (resp.statusCode == 204) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Hủy đơn thành công!"),
                                        ),
                                      );
                                      fetchDonNghiPhep();
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Hủy đơn thất bại, thử lại sau.",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                )
                                : null,
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
        SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFF0165FC), size: 20),
                SizedBox(width: 8),
                Text(
                  date != null ? dateFormat.format(date) : "Chọn ngày",
                  style: TextStyle(
                    fontSize: 16,
                    color: date != null ? Colors.black : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
