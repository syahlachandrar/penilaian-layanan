import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> data;
  final Map<double, DateTime> dateMap;

  const LineChartWidget({required this.data, required this.dateMap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double minY = data.isNotEmpty
        ? data.map((e) => e.y).reduce((a, b) => a < b ? a : b)
        : 1;
    double maxY = data.isNotEmpty
        ? data.map((e) => e.y).reduce((a, b) => a > b ? a : b)
        : 5;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF11892D),
            Color.fromRGBO(0, 132, 0, 0.459),
            Color.fromRGBO(255, 254, 254, 0.247),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "GRAFIK RATA-RATA ULASAN PELAYANAN",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          data.isEmpty
              ? Center(
                  child: Text(
                    "Tidak ada data untuk ditampilkan",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              reservedSize: 25,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                if (value >= minY && value <= maxY) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: data.length.toDouble() - 1,
                        minY: minY,
                        maxY: maxY,
                        lineBarsData: [
                          LineChartBarData(
                            spots: data,
                            isCurved: true,
                            barWidth: 2,
                            color: Color(0xFFFBD85D),
                            dotData: FlDotData(show: false),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Color.fromARGB(199, 0, 0, 0),
                              getTooltipItems: (List<LineBarSpot> TouchedSpot) {
                                return TouchedSpot.map((spot) {
                                  DateTime date = dateMap[spot.x] ?? DateTime.now();
                                  String formattedDate =
                                      "${date.day}-${date.month}-${date.year}";

                                  return LineTooltipItem(
                                    "Tanggal: $formattedDate\nRata-rata: ${spot.y}",
                                    TextStyle(color: Colors.white, fontSize: 9),
                                  );
                                }).toList();
                              }),
                        )
                        ),
                  ),
                ),
        ],
      ),
    );
  }
}
