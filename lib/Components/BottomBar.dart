import 'package:flutter/material.dart';
import 'package:unik/Page/Beranda.dart';
import 'package:unik/Page/Grafik.dart';
import 'package:unik/Page/Input.dart';
import 'package:unik/Page/Report.dart'; // Import halaman UlasanInputPage

class BottomBar extends StatefulWidget {
  final void Function()? onHomeTap;
  final void Function()? onCommentTap;
  final void Function()? onPersonTap;

  const BottomBar({
    Key? key,
    this.onHomeTap,
    this.onCommentTap,
    this.onPersonTap,
  }) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool _isHovered = false; // Menyimpan status hover

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1A841A),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIcon(Icons.home, Beranda()),
            _buildIcon(Icons.star, UlasanInputPage()),
            // _buildIcon(Icons.bar_chart, Grafik()),
            _buildIcon(Icons.person, LihatUlasanPage()),
          ]),
      ),
    );
    
  }

  Widget _buildIcon(IconData icon, Widget pageWidget) {
    return InkWell(
      onTap: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => pageWidget),
      ),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true; // Set hover to true
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false; // Set hover to false
            });
          },
          child: Icon(
            icon,
            color: _isHovered ? Colors.yellow : Colors.white,  // Change color on hover
          ),
        ),
      ),
    );
  }
}

