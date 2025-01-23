import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:unik/db/db_helper.dart';

class LineChartWidget extends StatefulWidget {
  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<FlSpot> _spots = [];
  bool _isLoading = true;
  String _selectedRange = "7"; // Default range: 7 hari terakhir
  double _minY = 1;
  double _maxY = 5;

  @override
  void initState() {
    super.initState();
    _loadChartData(_selectedRange);
  }

  Future<void> _loadChartData(String range) async {
    setState(() {
      _isLoading = true;
      _spots = [];
    });

    try {
      final data = await DatabaseHelper.getAverageRatingByRange(range);
      setState(() {
        _spots = data
            .asMap()
            .entries
            .map((entry) {
          final index = entry.key.toDouble();
          final averageRating = entry.value['averageRating'] as double?;
          if (averageRating == null || averageRating.isNaN) return null;
          return FlSpot(index, averageRating);
        })
            .where((spot) => spot != null)
            .cast<FlSpot>()
            .toList();
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
            Color(0xFF11892D),
            Color.fromRGBO(0, 132, 0, 0.459),
            Color.fromRGBO(255, 254, 254, 0.247),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "GRAFIK RATA-RATA ULASAN PELAYANAN",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _spots.isEmpty
              ? Center(child: Text("No valid data to display"))
              : SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value >= 1 && value <= 5) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: _spots.length.toDouble() - 1,
                minY: _minY,
                maxY: _maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: _spots,
                    isCurved: false,
                    barWidth: 1.5,
                    color: Color(0xFFFBD85D),
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 8.0,
            children: [
              _buildRangeButton("7", "7 Hari"),
              _buildRangeButton("30", "1 Bulan"),
              _buildRangeButton("90", "3 Bulan"),
              _buildRangeButton("180", "6 Bulan"),
              _buildRangeButton("365", "1 Tahun"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRangeButton(String range, String label) {
    final isSelected = _selectedRange == range;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedRange = range;
        });
        _loadChartData(range);
      },
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Colors.green : Colors.transparent,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 9,
        ),
      ),
    );
  }
}
