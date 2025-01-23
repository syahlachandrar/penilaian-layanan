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
  int totalReviews = 0;
  bool isLoading = true;

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
      lineChartData = avgRatingsByDate
          .asMap()
          .entries
          .map((entry) => FlSpot(
                entry.key.toDouble(),
                entry.value['averageRating'] as double,
              ))
          .toList();

      // Fetch rating distribution data
      final ratingData = await DatabaseHelper.getRatingDistribution();
      totalReviews = ratingData['totalReviews'] ?? 0;
      ratingDistribution = {
        5: (ratingData['fiveStars'] ?? 0) / totalReviews,
        4: (ratingData['fourStars'] ?? 0) / totalReviews,
        3: (ratingData['threeStars'] ?? 0) / totalReviews,
        2: (ratingData['twoStars'] ?? 0) / totalReviews,
        1: (ratingData['oneStar'] ?? 0) / totalReviews,
      };
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pieChartData = [
      PieChartSectionData(
        color: Colors.red,
        value: 30, // Example data
        title: '30%',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 14),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: 25,
        title: '25%',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 14),
      ),
      PieChartSectionData(
        color: Colors.yellow,
        value: 20,
        title: '20%',
        radius: 50,
        titleStyle: TextStyle(color: Colors.black, fontSize: 14),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 15,
        title: '15%',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 14),
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: 10,
        title: '10%',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 14),
      ),
    ];

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
                    LineChartWidget(data: lineChartData),
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
