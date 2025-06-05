import 'package:flutter/material.dart';

class LichSuKhamScreen extends StatefulWidget {
  const LichSuKhamScreen({super.key});

  @override
  State<LichSuKhamScreen> createState() => _LichSuKhamScreenState();
}

class _LichSuKhamScreenState extends State<LichSuKhamScreen> {
  String _selectedProfile = "Tất cả hồ sơ";
  String _selectedStatus = "Đã thanh toán";
  DateTime? _startDate, _endDate;
  bool _sortNewestFirst = true;

  final List<String> profiles = [
    "Tất cả hồ sơ",
    "Nguyễn Văn B",
    "Lê Minh Anh",
    "Trần Thanh Mai",
  ];
  final List<String> statusList = [
    "Đã thanh toán",
    "Đã tiếp nhận",
    "Đã khám",
    "Đã huỷ",
  ];

  Future<void> _chonNgay(BuildContext context, bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lịch sử khám",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0165FC),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              setState(() => _sortNewestFirst = !_sortNewestFirst);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chọn hồ sơ bệnh nhân
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: _selectedProfile,
              items:
                  profiles
                      .map(
                        (profile) => DropdownMenuItem(
                          value: profile,
                          child: Text(profile),
                        ),
                      )
                      .toList(),
              onChanged: (value) => setState(() => _selectedProfile = value!),
              decoration: const InputDecoration(
                labelText: "Chọn hồ sơ",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Chọn trạng thái với ScrollHorizon
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children:
                  statusList.map((status) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(status),
                        selected: _selectedStatus == status,
                        onSelected:
                            (selected) => setState(
                              () =>
                                  _selectedStatus =
                                      selected ? status : "Tất cả",
                            ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          // Bộ lọc thời gian
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Chọn ngày bắt đầu
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _chonNgay(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: Text(
                      _startDate != null
                          ? "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}"
                          : "Từ ngày",
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Chữ "Đến"
                const Text(
                  "⮕",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),

                // Chọn ngày kết thúc
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _chonNgay(context, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: Text(
                      _endDate != null
                          ? "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}"
                          : "Đến ngày",
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Bộ lọc sắp xếp
                DropdownButton<String>(
                  value: _sortNewestFirst ? "Mới nhất" : "Cũ nhất",
                  items:
                      ["Mới nhất", "Cũ nhất"]
                          .map(
                            (sortType) => DropdownMenuItem(
                              value: sortType,
                              child: Text(sortType),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() => _sortNewestFirst = value == "Mới nhất");
                  },
                ),
              ],
            ),
          ),

          // Danh sách lịch sử khám
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color.fromARGB(255, 216, 243, 255),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nguyễn Văn B",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("18-03-2025 - 10:00 AM"),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Trạng thái: ${statusList[index % statusList.length]}",
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("Xem chi tiết"),
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
        ],
      ),
    );
  }
}
