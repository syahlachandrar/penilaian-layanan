import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unik/Components/BottomBar.dart';
import 'package:unik/Components/Header.dart';
import 'package:unik/db/db_helper.dart';
import 'package:unik/db/Model.dart';

class LihatUlasanPage extends StatefulWidget {
  @override
  _LihatUlasanPageState createState() => _LihatUlasanPageState();
}

class _LihatUlasanPageState extends State<LihatUlasanPage> {
  List<Ulasan> _ulasanList = [];
  List<Ulasan> _filteredUlasanList = [];
  DateTime? _selectedDate;
  int? _selectedStar;

  @override
  void initState() {
    super.initState();
    _loadUlasan();
  }

  Future<void> _loadUlasan() async {
    final ulasanList = await DatabaseHelper.getAllUlasan();
    ulasanList.sort((a, b) => b.tanggalWaktu.compareTo(a.tanggalWaktu));

    setState(() {
      _ulasanList = ulasanList;
      _filteredUlasanList = _ulasanList;
    });
  }

  void _applyFilters() {
  setState(() {
    _filteredUlasanList = _ulasanList.where((ulasan) {
      bool matchesDate = _selectedDate == null ||
          DateFormat('yyyy-MM-dd').format(ulasan.tanggalWaktu) ==
              DateFormat('yyyy-MM-dd').format(_selectedDate!);

      bool matchesStar = _selectedStar == null ||
          ulasan.jumlahBintang == _selectedStar;

      return matchesDate && matchesStar;
    }).toList();
  });
}

// Fungsi untuk filter berdasarkan tanggal, yang memanggil _applyFilters
void _filterByDate(DateTime selectedDate) {
  setState(() {
    _selectedDate = selectedDate;
  });
  _applyFilters();
}

// Fungsi untuk filter berdasarkan rating, yang memanggil _applyFilters
void _filterByStar(int star) {
  setState(() {
    _selectedStar = star;
  });
  _applyFilters();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: Header(title: 'LAPORAN ULASAN PELAYANAN'),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
  mainAxisAlignment: MainAxisAlignment.center, // Center the children horizontally
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    // Date Picker
    GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2019),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null && pickedDate != _selectedDate) {
          _filterByDate(pickedDate);
        }
      },
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _selectedDate != null
                  ? "${DateFormat('dd/MM/yyyy').format(_selectedDate!)}"
                  : "Tanggal",
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
            SizedBox(width: 35),
            Icon(Icons.calendar_today, size: 13),
          ],
        ),
      ),
    ),
    SizedBox(width: 15),
    
    // Rating Dropdown
    Container(
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<int>(
        value: _selectedStar,
        underline: SizedBox(), // Remove the underline
        hint: Padding(
          padding: const EdgeInsets.only(left: 15, right: 50),
          child: Text(
            _selectedStar != null ? "$_selectedStar" : "Rating",
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ),
        onChanged: (int? newValue) {
          if (newValue != null) {
            _filterByStar(newValue);
          }
        },
        items: List.generate(5, (index) {
          return DropdownMenuItem<int>(
            value: index + 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${index + 1}",
                    style: TextStyle(fontSize: 11),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 13,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ),
    SizedBox(width: 10),
    // Reset Button (only visible when a filter is applied)
    if (_selectedDate != null || _selectedStar != null)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedDate = null;
              _selectedStar = null;
              _filteredUlasanList = _ulasanList; // Reset filter
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red, // Set the button color to red
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Button border radius
            ),
            minimumSize: Size(50, 30), 
          ),
          child: Text(
            "Reset",
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
        ),
      ),
  ],
),

            SizedBox(height: 5),
            Expanded(
              child: _filteredUlasanList.isEmpty
                  ? Center(child: Text("Tidak ada ulasan yang tersedia"))
                  : ListView.builder(
                      itemCount: _filteredUlasanList.length,
                      itemBuilder: (context, index) {
                        final ulasan = _filteredUlasanList[index];
                        String formattedDate = DateFormat('yyyy-MM-dd')
                            .format(ulasan.tanggalWaktu);
                        String formattedTime =
                            DateFormat('HH:mm').format(ulasan.tanggalWaktu);

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          elevation: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: List.generate(5, (indexStar) {
                                        return Icon(
                                          Icons.star,
                                          color:
                                              ulasan.jumlahBintang > indexStar
                                                  ? Colors.yellow
                                                  : Colors.grey,
                                          size: 25,
                                        );
                                      }),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "$formattedDate",
                                          style: TextStyle(fontSize: 9),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "${ulasan.id}",
                                          style: TextStyle(fontSize: 9),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "${ulasan.penilaian.join(', ')}",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF1A841A),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "${ulasan.pesan}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
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
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
