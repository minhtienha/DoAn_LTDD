import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:5001/';
  } else {
    return 'http://10.0.2.2:5001/';
  }
}

class LichSuKhamScreen extends StatefulWidget {
  final int maNguoiDung;
  const LichSuKhamScreen({super.key, required this.maNguoiDung});

  @override
  State<LichSuKhamScreen> createState() => _LichSuKhamScreenState();
}

class _LichSuKhamScreenState extends State<LichSuKhamScreen> {
  List<Map<String, dynamic>> _profiles = [];
  int? _selectedMaHoSo;

  String _selectedStatus = 'Tất cả';
  String _selectedTrangThaiKham = 'Tất cả';
  DateTime? _startDate, _endDate;
  bool _sortNewestFirst = true;

  List<Map<String, dynamic>> _history = [];

  late Future<void> _initialLoad;

  @override
  void initState() {
    super.initState();
    _initialLoad = _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final url =
        '${getBaseUrl()}api/HoSoBenhNhan/NguoiDung/${widget.maNguoiDung}';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is List) {
        _profiles = List<Map<String, dynamic>>.from(data);
      }
    }
    if (_profiles.isNotEmpty) {
      _selectedMaHoSo = _profiles.first['maHoSo'] as int;
      await _loadHistory();
    }
  }

  Future<void> _loadHistory() async {
    if (_selectedMaHoSo == null) {
      _history = [];
      return;
    }
    final url = '${getBaseUrl()}api/LichKham/HoSo/$_selectedMaHoSo';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is List) {
        _history = List<Map<String, dynamic>>.from(data);
      }
    } else {
      _history = [];
    }
  }

  Future<void> _onProfileChanged(int? newMaHoSo) async {
    if (newMaHoSo == null) return;
    setState(() => _selectedMaHoSo = newMaHoSo);
    await _loadHistory();
    setState(() {});
  }

  Future<void> _huyLich(int maLichKham) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận'),
            content: const Text('Bạn có chắc muốn huỷ lịch khám này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Không'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Huỷ'),
              ),
            ],
          ),
    );
    if (confirm != true) return;

    final url = '${getBaseUrl()}api/LichKham/Huy/$maLichKham';
    final resp = await http.put(Uri.parse(url));
    if (resp.statusCode == 200) {
      await _loadHistory();
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã huỷ lịch thành công.')));
    } else {
      String message = 'Huỷ lịch thất bại.';
      try {
        final data = jsonDecode(resp.body);
        message = data['message'] ?? message;
      } catch (_) {}
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "Đã thanh toán":
        return Colors.green;
      case "Đã huỷ":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusOptions = ['Tất cả', 'Đã thanh toán', 'Đã hủy'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch sử khám',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0165FC),
        actions: [
          IconButton(
            icon: Icon(
              _sortNewestFirst ? Icons.arrow_downward : Icons.arrow_upward,
              color: Colors.white,
            ),
            onPressed:
                () => setState(() => _sortNewestFirst = !_sortNewestFirst),
            tooltip: _sortNewestFirst ? 'Mới nhất trước' : 'Cũ nhất trước',
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initialLoad,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Áp filter & sort lên _history
          var filtered =
              _history.where((item) {
                if (_selectedStatus != 'Tất cả' &&
                    item['trangThaiTT'] != _selectedStatus) {
                  return false;
                }
                if (_selectedTrangThaiKham != 'Tất cả' &&
                    item['trangThaiKham'] != _selectedTrangThaiKham) {
                  return false;
                }
                final dt = DateTime.parse(item['thoiGianKham']);
                if (_startDate != null &&
                    dt.isBefore(
                      DateTime(
                        _startDate!.year,
                        _startDate!.month,
                        _startDate!.day,
                      ),
                    )) {
                  return false;
                }
                if (_endDate != null &&
                    dt.isAfter(
                      DateTime(
                        _endDate!.year,
                        _endDate!.month,
                        _endDate!.day,
                        23,
                        59,
                        59,
                      ),
                    )) {
                  return false;
                }
                return true;
              }).toList();

          filtered.sort((a, b) {
            final da = DateTime.parse(a['ngayTao']);
            final db = DateTime.parse(b['ngayTao']);
            return db.compareTo(da); // Mới nhất trước
          });
          print(_history);
          return Column(
            children: [
              // Chọn hồ sơ
              Padding(
                padding: const EdgeInsets.all(12),
                child: DropdownButtonFormField<int>(
                  value: _selectedMaHoSo,
                  items:
                      _profiles
                          .map(
                            (p) => DropdownMenuItem(
                              value: p['maHoSo'] as int,
                              child: Text(p['hoVaTen'] ?? ''),
                            ),
                          )
                          .toList(),
                  onChanged: _onProfileChanged,
                  decoration: const InputDecoration(
                    labelText: 'Chọn hồ sơ',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              // Lọc trạng thái
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  items:
                      statusOptions
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _selectedStatus = v!),
                  decoration: const InputDecoration(
                    labelText: 'Trạng thái thanh toán',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  value: _selectedTrangThaiKham,
                  items:
                      ['Tất cả', 'Đã khám', 'Chưa khám']
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _selectedTrangThaiKham = v!),
                  decoration: const InputDecoration(
                    labelText: 'Trạng thái khám',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Danh sách lịch sử
              Expanded(
                child:
                    filtered.isEmpty
                        ? const Center(child: Text('Không có bản ghi phù hợp.'))
                        : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filtered.length,
                          itemBuilder: (c, i) {
                            final item = filtered[i];
                            final dt = DateTime.parse(item['thoiGianKham']);
                            final dateStr =
                                '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
                                '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

                            final hoSo = item['hoSoBenhNhan'] ?? {};
                            final bacSi = item['bacSi'] ?? {};

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.blue[200],
                                          radius: 22,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            bacSi['hoVaTen'] ?? '---',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF0165FC),
                                            ),
                                          ),
                                        ),
                                        Chip(
                                          label: Text(
                                            item['trangThaiTT'] ?? '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor: statusColor(
                                            item['trangThaiTT'] ?? '',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Thông tin lịch
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          dateStr,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    if ((item['khungGio'] ?? '').isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 6.0,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 18,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              item['khungGio'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            hoSo['hoVaTen'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.attach_money,
                                            size: 18,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "${item['gia']} đ",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.verified,
                                            size: 18,
                                            color:
                                                item['trangThaiKham'] ==
                                                        'Đã khám'
                                                    ? Colors.green
                                                    : Colors.orange,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            item['trangThaiKham'] ?? '',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color:
                                                  item['trangThaiKham'] ==
                                                          'Đã khám'
                                                      ? Colors.green
                                                      : Colors.orange,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Nút hủy lịch
                                    if (item['trangThaiTT'] != 'Đã huỷ')
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: TextButton.icon(
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                          label: const Text(
                                            'Huỷ lịch',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed:
                                              () =>
                                                  _huyLich(item['maLichKham']),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
