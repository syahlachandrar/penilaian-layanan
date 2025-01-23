import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SatisfactionPieChart extends StatelessWidget {
  final List<PieChartSectionData> pieChartData;

  SatisfactionPieChart({required this.pieChartData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'ASPEK KEPUASAN PELAYANAN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: pieChartData,
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: [
            LegendItem(color: Colors.red, text: 'Kompetensi Petugas'),
            LegendItem(color: Colors.blue, text: 'Sarana Prasarana'),
            LegendItem(color: Colors.yellow, text: 'Kualitas Pelayanan'),
            LegendItem(color: Colors.green, text: 'Sikap Petugas'),
            LegendItem(color: Colors.purple, text: 'Waktu Pelayanan'),
          ],
        ),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
