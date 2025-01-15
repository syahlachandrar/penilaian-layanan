import 'package:flutter/material.dart';
import 'package:unik/Page/Beranda.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      titleSpacing: 0.5,
      title: Padding(
        padding: const EdgeInsets.only(top: 5,bottom:5,right: 6, left: 6),
        child: Container(
          height: 48,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1A841A), // Warna hijau dengan kode #1A841A
                ),
                child: IconButton(
                  padding: EdgeInsets.zero, // Menghilangkan padding default pada IconButton
                  iconSize: 18,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Beranda()), // Replace HomeScreen() with your home page widget
                    );

                  },
                ),
              ),
              Expanded(
                child: Center( // Membuat teks berada di tengah secara horizontal dan vertikal
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}