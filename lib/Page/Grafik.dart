import 'package:fl_chart/fl_chart.dart'; 
import 'package:flutter/material.dart';
import 'package:unik/Components/BottomBar.dart';
import 'package:unik/Components/Header.dart';
import 'package:unik/Components/LineChart.dart';
import 'package:unik/Components/RatingDistribution.dart';
import 'package:unik/Components/PieChart.dart';
import 'package:unik/db/db_helper.dart';

class Grafik extends StatefulWidget {
  @override
  _GrafikState createState() => _GrafikState();
}

class _GrafikState extends State<Grafik> {
  List<FlSpot> lineChartData = [];
  Map<int, double> ratingDistribution = {};
  Map<double, DateTime> dateMap = {};
  int totalReviews = 0;
  bool isLoading = true;
  List<PieChartSectionData> pieChartData = [];

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch line chart data
      final avgRatingsByDate = await DatabaseHelper.getAverageRatingByDate();
      Map<double, DateTime> tempDateMap = {};
      lineChartData = avgRatingsByDate.asMap().entries.map((entry) {
        double x = entry.key.toDouble();
        double y = (entry.value['averageRating'] as num).toDouble();
        DateTime date = DateTime.parse(entry.value['date']);
        tempDateMap[x] = date;
        return FlSpot(x, y);
      }).toList();
      dateMap = tempDateMap;

      // Fetch rating distribution data
      final ratingData = await DatabaseHelper.getRatingDistribution();
      totalReviews = (ratingData['totalReviews'] ?? 0) as int;

      if (totalReviews > 0) {
        ratingDistribution = {
          5: ((ratingData['fiveStars'] ?? 0) as int) / totalReviews,
          4: ((ratingData['fourStars'] ?? 0) as int) / totalReviews,
          3: ((ratingData['threeStars'] ?? 0) as int) / totalReviews,
          2: ((ratingData['twoStars'] ?? 0) as int) / totalReviews,
          1: ((ratingData['oneStar'] ?? 0) as int) / totalReviews,
        };
      } else {
        ratingDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
      }

      // Fetch data untuk Pie Chart
      List<PieChartSectionData> tempPieChartData = await generatePieChartData();

      // Update state dengan data yang telah diambil
      setState(() {
        pieChartData = tempPieChartData;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<PieChartSectionData>> generatePieChartData() async {
  final Map<String, int> penilaianCountsMap = await DatabaseHelper.getPenilaianCounts();
  
  print("Penilaian Counts: $penilaianCountsMap");

  if (penilaianCountsMap.isEmpty) return [];

  // Konversi Map ke List<Map<String, dynamic>>
  List<Map<String, dynamic>> penilaianCounts = penilaianCountsMap.entries.map((entry) {
    return {"penilaian": entry.key, "count": entry.value};
  }).toList();

  int total = penilaianCounts.fold(0, (sum, item) => sum + (item['count'] as int));
  total = total == 0 ? 1 : total; // Mencegah pembagian dengan nol

  Map<String, Color> kategoriWarna = {
    'Kompetensi Petugas': Colors.red,
    'Sarana Prasarana': Colors.blue,
    'Kualitas Pelayanan': Colors.yellow,
    'Sikap Petugas': Colors.green,
    'Waktu Pelayanan': Colors.purple,
  };

  return penilaianCounts.map((item) {
    String kategori = item['penilaian'].toString();
    int count = item['count'] as int;
    double percentage = (count / total) * 100;

    print("Kategori: $kategori, Count: $count, Warna: ${kategoriWarna[kategori]}");

    return PieChartSectionData(
      color: kategoriWarna[kategori] ?? Colors.grey,
      value: percentage,
      title: '${percentage.toStringAsFixed(1)}%',
      radius: 60,
      titleStyle: const TextStyle(color: Colors.white, fontSize: 10),
    );
  }).toList();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: Header(title: 'STATISTIK ULASAN PELAYANAN'),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LineChartWidget(data: lineChartData, dateMap: dateMap),
                    const SizedBox(height: 20),
                    RatingDistributionWidget(
                      totalReviews: totalReviews,
                      ratings: ratingDistribution,
                    ),
                    const SizedBox(height: 20),
                    SatisfactionPieChart(pieChartData: pieChartData),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
