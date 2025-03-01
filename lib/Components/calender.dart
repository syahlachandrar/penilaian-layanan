import 'package:flutter/material.dart';
import 'package:unik/db/db_helper.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  int _reviewCount = 0;
  double _averageRating = 0.0;
  DateTime _currentDate = DateTime.now(); // Tanggal yang ditampilkan
  DateTime _selectedDate = DateTime.now(); // Tanggal yang dipilih
  late String _currentMonth;

  @override
  void initState() {
    super.initState();
    _updateMonthYear();
    _fetchReviewData(); // Mengambil data berdasarkan tanggal awal
  }

  void _updateMonthYear() {
    setState(() {
      _currentMonth = "${_getMonthName(_currentDate.month)} ${_currentDate.year}";
    });
  }

  Future<void> _fetchReviewData() async {
    final count = await DatabaseHelper.countUlasanByDate(_selectedDate);
    final average = await DatabaseHelper.averageUlasanByDate(_selectedDate);

    setState(() {
      _reviewCount = count;
      _averageRating = average;
    });
  }

  String _getMonthName(int month) {
    List<String> months = [
      "JANUARI", "FEBRUARI", "MARET", "APRIL", "MEI", "JUNI",
      "JULI", "AGUSTUS", "SEPTEMBER", "OKTOBER", "NOVEMBER", "DESEMBER"
    ];
    return months[month - 1];
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      if (_selectedDate.month != _currentDate.month || _selectedDate.year != _currentDate.year) {
        _currentDate = _selectedDate;
        _updateMonthYear();
      }
    });

    // Perbarui data ulasan saat tanggal berubah
    _fetchReviewData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _currentMonth,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx < 0) {
              _onDateSelected(_currentDate.add(Duration(days: 1)));
            } else if (details.delta.dx > 0) {
              _onDateSelected(_currentDate.subtract(Duration(days: 1)));
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) {
              DateTime displayDate = _currentDate.add(Duration(days: index - 3));
              bool isSelected = displayDate.day == _selectedDate.day &&
                  displayDate.month == _selectedDate.month &&
                  displayDate.year == _selectedDate.year;

              return GestureDetector(
                onTap: () => _onDateSelected(displayDate),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: isSelected ? Color(0xFF1A841A) : Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Color(0xFF58DDAF),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${displayDate.day}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 15),
        Text(
          'Jumlah ulasan :',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 8),
        Text(
          '$_reviewCount ulasan',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 15),
        Text(
          'Rata-rata ulasan :',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 8),
        Text(
          _averageRating.toStringAsFixed(1),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildStarIcons(),
          ),
        ),
        SizedBox(height: 20),
        Image.asset(
          'assets/line.png', // Pastikan path sesuai dengan file image
          fit: BoxFit.scaleDown,
          width: 448,
        ),
      ],
    );
  }

  List<Widget> _buildStarIcons() {
    int fullStars = _averageRating.floor();
    bool hasHalfStar = (_averageRating - fullStars) >= 0.5;
    List<Widget> stars = [];

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow, size: 15));
    }

    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow, size: 15));
    }

    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: Colors.yellow, size: 15));
    }

    return stars;
  }
}
