import 'package:doan_nhom06/GiaoDien_BenhNhan/trangXacNhanTtKham.dart';
import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  final String specialty;
  final String service;
  final String date;
  final String time;
  // final Map<String, String> clinic;

  const PersonalInfoPage({
    super.key,
    // required this.clinic,
    required this.specialty,
    required this.service,
    required this.date,
    required this.time,
  });

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  String? _selectedGender;
  DateTime? _selectedDate;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _selectGender() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Wrap(
            children:
                ['Nam', 'Nữ']
                    .map(
                      (gender) => ListTile(
                        title: Text(gender),
                        onTap:
                            () => setState(() {
                              _selectedGender = gender;
                              Navigator.pop(context);
                            }),
                      ),
                    )
                    .toList(),
          ),
        );
      },
    );
  }

  void _validateAndSubmit() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedDate == null ||
        _selectedGender == null ||
        _cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin!'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tạo hồ sơ thành công!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ConfirmBookingPage(
                  name: _nameController.text.trim(),
                  phone: _phoneController.text.trim(),
                  birthDate:
                      "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  gender: _selectedGender!,
                  city: _cityController.text.trim(),
                  specialty: widget.specialty,
                  service: widget.service,
                  date: widget.date,
                  time: widget.time,
                  // clinic: widget.clinic,
                ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tạo mới hồ sơ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0165FC),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      'Họ và tên (có dấu)',
                      'Nhập họ và tên',
                      true,
                      controller: _nameController,
                    ),
                    _buildTextField(
                      'Số điện thoại',
                      'Nhập số điện thoại',
                      true,
                      prefix: Text('+84 '),
                      controller: _phoneController,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            'Ngày sinh',
                            _selectedDate != null
                                ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                                : 'Ngày / Tháng / Năm',
                            true,
                            () => _selectDate(context),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildDropdownField(
                            'Giới tính',
                            _selectedGender ?? 'Giới tính',
                            true,
                            _selectGender,
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(
                      'Tỉnh / TP',
                      'Nhập tỉnh thành',
                      true,
                      controller: _cityController,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _validateAndSubmit();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF0165FC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 5,
              ),
              child: const Text(
                'Tạo mới hồ sơ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField(
  String label,
  String hint,
  bool isRequired, {
  Widget? prefix,
  TextEditingController? controller,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            children:
                isRequired
                    ? [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                    ]
                    : [],
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefix: prefix,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 65, 118, 209),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 65, 118, 209),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 65, 118, 209),
                width: 2,
              ),
            ),
          ),
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ],
    ),
  );
}

Widget _buildDateField(
  String label,
  String hint,
  bool isRequired,
  VoidCallback onTap,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        TextField(
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 65, 118, 209),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 65, 118, 209),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 65, 118, 209),
                width: 2,
              ),
            ),
            suffixIcon: Icon(Icons.calendar_today, color: Colors.blue),
          ),
          style: TextStyle(fontSize: 20),
        ),
      ],
    ),
  );
}

Widget _buildDropdownField(
  String label,
  String hint,
  bool isRequired,
  VoidCallback onTap,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        TextField(
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 65, 118, 209),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 65, 118, 209),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 65, 118, 209),
                width: 2,
              ),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.blue),
          ),
          style: TextStyle(fontSize: 20),
        ),
      ],
    ),
  );
}

Widget _buildLabel(String label, bool isRequired) {
  return RichText(
    text: TextSpan(
      text: label,
      style: TextStyle(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      children:
          isRequired
              ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
              : [],
    ),
  );
}
