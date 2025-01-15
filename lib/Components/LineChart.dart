import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:unik/db/db_helper.dart';

class LineChartWidget extends StatefulWidget {
  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<FlSpot> _spots = [];
  List<String> _dates = [];
  bool _isLoading = true;
  String _selectedRange = "7 Days"; // Default range
  double _minY = 0;
  double _maxY = 5; // Nilai default maxY (akan disesuaikan)

  @override
  void initState() {
    super.initState();
    _loadChartData("7"); // Default 7 days data
  }

  Future<void> _loadChartData(String range) async {
    try {
      // Ambil data dari database berdasarkan rentang waktu yang dipilih
      final data = await DatabaseHelper.getAverageRatingByRange(range);
      print("Data fetched: $data");

      // Menentukan minY dan maxY berdasarkan data
      double maxBintang = 0;
      double minBintang = double.infinity;

      setState(() {
        _spots = data
            .asMap()
            .entries
            .map((entry) {
              final index = entry.key.toDouble();
              final averageRating = entry.value['averageRating'] as double?;
              if (averageRating == null ||
                  averageRating.isNaN ||
                  averageRating.isInfinite) {
                return null; // Abaikan data yang tidak valid
              }
              _dates.add(entry.value['date'].toString());

              // Menghitung minY dan maxY
              if (averageRating > maxBintang) maxBintang = averageRating;
              if (averageRating < minBintang) minBintang = averageRating;

              return FlSpot(index, averageRating);
            })
            .where((spot) => spot != null)
            .cast<FlSpot>()
            .toList();

        // Set nilai minY dan maxY
        _minY = minBintang;
        _maxY = maxBintang > 5 ? maxBintang : 5; // Menyesuaikan dengan nilai maxY yang lebih besar dari 5
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF11892D), // Hijau pekat
            Color.fromRGBO(0, 132, 0, 0.459), // Hijau semi-transparan
            Color.fromRGBO(255, 254, 254, 0.247), // Abu-abu terang transparan
          ],
          stops: [0.2658, 0.7223, 1.0], // Posisi gradien
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Judul grafik
          Text(
            "GRAFIK RATA-RATA ULASAN PELAYANAN",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 255, 255, 255), // Warna teks kuning terang
            ),
          ),
          SizedBox(height: 20), // Jarak antara judul dan grafik
          _isLoading
              ? Center(child: CircularProgressIndicator()) // Loading
              : _spots.isEmpty
                  ? Center(child: Text("No valid data to display")) // Data kosong
                  : SizedBox(
                      height: 200, // Tinggi grafik
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: false,
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < _dates.length) {
                                    return Text(_dates[index]);
                                  }
                                  return Container();
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                getTitlesWidget: (value, meta) {
                                  if (value == _minY || value == _maxY) {
                                    return Text(value.toString());
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true), // Menambahkan border
                          minX: 0,
                          maxX: _spots.isNotEmpty
                              ? _spots.length.toDouble() - 1
                              : 0,
                          minY: _minY,
                          maxY: _maxY,
                          lineBarsData: [
                            LineChartBarData(
                              spots: _spots,
                              isCurved: true,
                              barWidth: 1.5,
                              color: Color(0xFFFBD85D), // Warna garis grafik
                              belowBarData: BarAreaData(
                                show: false,
                              ),
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}
