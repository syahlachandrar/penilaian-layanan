import 'package:flutter/material.dart';
import 'package:unik/Components/BottomBar.dart';
import 'package:unik/Components/Header.dart';
import 'package:unik/Components/LineChart.dart';

class Grafik extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: Header(title: 'STATISTIK ULASAN PELAYANAN'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LineChartWidget()
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}