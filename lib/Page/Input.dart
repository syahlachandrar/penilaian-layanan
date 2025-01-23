import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pastikan package intl ditambahkan di pubspec.yaml
import 'package:unik/Components/BottomBar.dart';
import 'package:unik/Components/Header.dart';
import 'package:unik/db/db_helper.dart';
import 'package:unik/db/Model.dart';

class UlasanInputPage extends StatefulWidget {
  @override
  _UlasanInputPageState createState() => _UlasanInputPageState();
}

class _UlasanInputPageState extends State<UlasanInputPage> {
  int _nextId = 1;
  final TextEditingController _pesanController = TextEditingController();
  double _rating = 0;
  Map<String, bool> _penilaian = {
    'Sikap Petugas': false,
    'Kualitas Pelayanan': false,
    'Kompetensi Petugas': false,
    'Waktu Pelayanan': false,
    'Sarana Prasarana': false,
  };

  @override
  void initState() {
    super.initState();
    _getNextId(); // Mengambil ID berikutnya saat halaman diinisialisasi
  }

  // Fungsi untuk mendapatkan ID berikutnya dari database
  Future<void> _getNextId() async {
    final ulasanList = await DatabaseHelper.getAllUlasan();
    setState(() {
      _nextId = (ulasanList.isNotEmpty) ? ulasanList.last.id! + 1 : 1;
    });
  }

  // Fungsi untuk menyimpan ulasan ke database
  Future<void> _saveUlasan() async {
    List<String> aspekTerpilih = _penilaian.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    Ulasan ulasan = Ulasan(
      id: _nextId,
      tanggalWaktu: DateTime.now(),
      jumlahBintang: _rating.toInt(),
      penilaian: aspekTerpilih,
      pesan: _pesanController.text,
    );
    await DatabaseHelper.insertUlasan(ulasan);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ulasan berhasil disimpan!")),
    );

    setState(() {
      _rating = 0;
      _pesanController.clear();
      _penilaian.updateAll((key, value) => false);
      _getNextId(); // Memperbarui ID berikutnya setelah menyimpan
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(title: 'ULASAN PELAYANAN'),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 5, bottom: 10, right: 15, left: 15),
        child: Center(
          // Center the entire content
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Align items in the center
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Baris ID, Tanggal, dan Jam
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10), // Menambahkan padding di dalam container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Border radius 20
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A841A), // Warna awal (#1a841a)
                      Color(0xFF58DDAF), // Warna akhir (#58ddaf)
                    ],
                    stops: [0.0192, 1.0], // Mengatur posisi warna pada gradasi
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$formattedDate",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors
                            .white, // Warna teks disesuaikan agar terlihat jelas
                      ),
                    ),
                    Text(
                      "$_nextId",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors
                            .white, // Warna teks disesuaikan agar terlihat jelas
                      ),
                    ),
                    Text(
                      "$formattedTime",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors
                            .white, // Warna teks disesuaikan agar terlihat jelas
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              // Rating Bintang
              Text(
                "Bagaimana Pelayanannya?",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5),
              Text(
                "(1 Tidak Puas, 5 Sangat Puas)",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the stars
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: _rating > index ? Colors.yellow : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 15),

              // Button untuk memilih aspek yang dipilih
              Text(
                "Apa yang menurutmu oke?",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: _penilaian.keys.map((aspek) {
                  return Container(
                    width: MediaQuery.of(context).size.width / 2 -
                        20, // Ensure all items have the same width
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _penilaian[aspek] = !_penilaian[aspek]!;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                        decoration: BoxDecoration(
                          color: _penilaian[aspek]!
                              ? Color(0xFF1A841A)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: _penilaian[aspek]!
                                ? Colors.transparent
                                : Color(0xFF1A841A),
                            width: 1,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center, // Center text
                          child: Text(
                            aspek,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Poppins',
                              color: _penilaian[aspek]!
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center, // Center the text
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // TextArea untuk input pesan
              Text(
                "Berikan pesan untuk kami :",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _pesanController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(5), // Border radius of 5px
                    borderSide: BorderSide(
                      color: Color(0xFF1A841A), // Border color #1a841a
                      width: 1, // Border width
                    ),
                  ),
                  hintText: "Tulis pesan ulasan Anda...",
                  hintStyle:
                      TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                  filled: true, // Ensure the background color is applied
                  fillColor: Color(0x331A841A),
                ),
              ),
              SizedBox(height: 12),

              // Tombol untuk menyimpan ulasan
              ElevatedButton(
                onPressed: _saveUlasan,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF1A841A), // White text color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5), // Border radius of 5px
                  ),
                  // Optional: makes the button wider
                ),
                child: Text(
                  "Simpan",
                  style: TextStyle(
                    fontSize: 12, // Font size 14
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
