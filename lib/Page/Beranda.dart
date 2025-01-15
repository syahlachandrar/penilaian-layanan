import 'package:flutter/material.dart';
import 'package:unik/Components/BottomBar.dart';
import 'package:unik/Components/calender.dart';
import 'package:unik/Components/result.dart';
import 'package:unik/Components/welcome.dart';

class Beranda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Welcome(),
            SizedBox(height: 10), // Jarak antara Welcome dan CalendarWidget
            CalendarWidget(),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.all(
                  16.0), // Sesuaikan dengan ukuran padding yang diinginkan
              child: ResultUlasan(),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
