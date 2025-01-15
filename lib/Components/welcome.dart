import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Layer: Background Container
          Container(
            width: double.infinity,
            height: 198,
            color: Colors.white, // Tambahkan warna latar belakang
          ),
          // Layer: Image
          Positioned(
            left: -35.46, // Posisi horizontal
            top: -15,
            child: Image.asset(
              'assets/Group1.png', // Pastikan path sudah sesuai dengan file image
              fit: BoxFit.scaleDown,
              width: 448,
            ),
          ),
          // Layer: Text
          Positioned(
            top: 40,
            left: 16, // Menambahkan margin kiri
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0), // Margin kiri
              child: Text(
                'Selamat Datang !',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
