import 'package:flutter/material.dart';
import 'package:unik/db/db_helper.dart';
import 'package:unik/db/Model.dart'; // Pastikan model Ulasan sudah terimport
import 'package:unik/Page/Report.dart'; // Pastikan halaman LihatUlasanPage sudah terimport

class ResultUlasan extends StatefulWidget {
  @override
  _ResultUlasanState createState() => _ResultUlasanState();
}

class _ResultUlasanState extends State<ResultUlasan> {
  List<Ulasan> _ulasanList = [];

  @override
  void initState() {
    super.initState();
    _loadUlasan();
  }

  // Fungsi untuk memuat ulasan terbaru
  Future<void> _loadUlasan() async {
    final ulasanList =
        await DatabaseHelper.getRecentUlasan(); // Memanggil method statis
    setState(() {
      _ulasanList = ulasanList; // Menyimpan List<Ulasan> ke dalam _ulasanList
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0x331A841A),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selengkapnya button on the top-right
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                // Navigate to LihatUlasanPage when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LihatUlasanPage()),
                );
              },
              child: Text(
                'Selengkapnya...',
                style: TextStyle(
                  fontSize: 10,
                  color: const Color.fromARGB(255, 138, 138, 138),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          // Displaying the list of reviews
          _ulasanList.isEmpty
              ? Center(child: Text("Tidak ada ulasan yang tersedia"))
              : SingleChildScrollView(
                  child: Column(
                    children: _ulasanList.map((ulasan) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        elevation: 0, // No shadow
                        color: Colors.transparent, // Transparent background
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Menampilkan bintang sesuai dengan jumlah bintang
                              Row(
                                children: List.generate(5, (indexStar) {
                                  return Icon(
                                    Icons.star,
                                    color: ulasan.jumlahBintang > indexStar
                                        ? const Color.fromARGB(255, 247, 223, 11)
                                        : Colors.grey,
                                    size: 15,
                                  );
                                }),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              // Menampilkan pesan dari ulasan
                              Text(
                                "${ulasan.pesan}",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 8),
                              // Add a Divider as bottom border
                              Divider(
                                color: Colors.grey,
                                thickness: 1,// Space between content and divider
                                height: 0,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }
}
