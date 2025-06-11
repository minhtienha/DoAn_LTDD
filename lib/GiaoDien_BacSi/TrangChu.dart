import 'package:doan_nhom06/GiaoDien_BacSi/LichKhamBenh.dart';
import 'package:doan_nhom06/DangNhap.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class TrangChuBacSi extends StatefulWidget {
  final int userId;
  const TrangChuBacSi({super.key, required this.userId});

  @override
  State<TrangChuBacSi> createState() => _TrangChuBacSiState();
}

class _TrangChuBacSiState extends State<TrangChuBacSi> {
  Map<String, dynamic>? bacSi;
  Timer? _timer;
  int _soThongBaoMoi = 0;
  Future<void> _loadBacSi() async {
    final url = '${getBaseUrl()}api/BacSi/${widget.userId}';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      setState(() {
        bacSi = jsonDecode(resp.body);
      });
    }
  }

  Future<void> _showThongBao(BuildContext context) async {
    final url = '${getBaseUrl()}api/ThongBao';
    final resp = await http.get(Uri.parse(url));
    List<dynamic> thongBaoList = [];
    if (resp.statusCode == 200) {
      thongBaoList =
          jsonDecode(
            resp.body,
          ).where((tb) => tb['maNguoiNhan'] == bacSi?['maBacSi']).toList();
      thongBaoList.sort(
        (a, b) => DateTime.parse(
          b['ngayTao'],
        ).compareTo(DateTime.parse(a['ngayTao'])),
      );
    }
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Container(
            height: 400,
            padding: EdgeInsets.all(16),
            child:
                thongBaoList.isEmpty
                    ? Center(child: Text("Không có thông báo nào!"))
                    : ListView.builder(
                      itemCount: thongBaoList.length,
                      itemBuilder: (ctx, i) {
                        final tb = thongBaoList[i];
                        return ListTile(
                          leading: Icon(
                            Icons.notifications,
                            color:
                                tb['trangThaiDoc'] == false ||
                                        tb['trangThaiDoc'] == null
                                    ? Colors.red
                                    : Colors.blue,
                          ),
                          title: Text(tb['noiDung'] ?? ''),
                          subtitle: Text(
                            tb['ngayTao'] != null
                                ? tb['ngayTao']
                                    .toString()
                                    .substring(0, 16)
                                    .replaceFirst('T', ' ')
                                : '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      },
                    ),
          ),
    );

    // Đánh dấu tất cả là đã đọc (nếu muốn)
    for (final tb in thongBaoList) {
      if (tb['trangThaiDoc'] == false || tb['trangThaiDoc'] == null) {
        await http.put(
          Uri.parse('${getBaseUrl()}api/ThongBao/${tb['maThongBao']}'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "maThongBao": tb['maThongBao'],
            "maNguoiNhan": tb['maNguoiNhan'],
            "noiDung": tb['noiDung'],
            "trangThaiDoc": true,
            "ngayTao": tb['ngayTao'],
          }),
        );
      }
    }

    setState(() {
      _soThongBaoMoi = 0;
    });
  }

  Future<void> _capNhatSoThongBaoMoi() async {
    final url = 'http://localhost:5001/api/ThongBao';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      final thongBaoList =
          jsonDecode(resp.body)
              .where(
                (tb) =>
                    tb['maNguoiNhan'] == bacSi?['maBacSi'] &&
                    (tb['trangThaiDoc'] == false || tb['trangThaiDoc'] == null),
              )
              .toList();
      setState(() {
        _soThongBaoMoi = thongBaoList.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBacSi();
    _capNhatSoThongBaoMoi();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (mounted) _capNhatSoThongBaoMoi();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (bacSi == null) {
      // Hiển thị loading khi chưa có dữ liệu
      return Scaffold(
        backgroundColor: Colors.blue[50],
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage("assets/images/my-avatar.jpg") as ImageProvider,
              radius: 22,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bacSi?['hoVaTen'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Chuyên khoa: ${bacSi?['chuyenKhoa']?['tenChuyenKhoa'] ?? ''}",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            Spacer(),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  tooltip: "Thông báo",
                  onPressed: () => _showThongBao(context),
                ),
                if (_soThongBaoMoi > 0)
                  Positioned(
                    right: 0,
                    top: 4,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                      child: Text(
                        '$_soThongBaoMoi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              tooltip: "Đăng xuất",
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DangNhap()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                LichKhamBenhBacSi(maBacSi: bacSi?['maBacSi']),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_note, size: 60, color: Colors.blue),
                        SizedBox(height: 18),
                        Text(
                          "Danh sách lịch khám",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Xem tất cả lịch khám mà bệnh nhân đã đặt cho bạn.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Chào mừng bạn đến với hệ thống quản lý lịch khám!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
