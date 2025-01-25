import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class Reports extends StatefulWidget {
  Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // 4 tabs: Daily, Weekly, Monthly, Yearly
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '                                                            PALSUN',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 5.0,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
          ],
          indicatorColor: Colors.orange,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChart('Daily Report', _dailySpots(), _dailyXLabels, 2), // Daily
          _buildChart('Weekly Report', _weeklySpots(), _weeklyXLabels, 1), // Weekly
          _buildChart('Monthly Report', _monthlySpots(), _monthlyXLabels, 5), // Monthly
          _buildChart('Yearly Report', _yearlySpots(), _yearlyXLabels, 1), // Yearly
        ],
      ),
    );
  }

  // Chart builder function
  Widget _buildChart(String title, List<FlSpot> spots, List<String> xLabels, int labelSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.grey[800]!,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.x.toInt()}: ${spot.y.toStringAsFixed(1)}',
                          TextStyle(color: Colors.orange, fontSize: 12),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(show: false), // Remove grid lines
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index % labelSpacing == 0 && index >= 0 && index < xLabels.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              xLabels[index],
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 2.5,
                    belowBarData: BarAreaData(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.orange.withOpacity(0.5), Colors.transparent],
                      ),
                      show: true,
                    ),
                    dotData: FlDotData(show: false), // Remove dots on the line
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Generate x-axis labels
  List<String> get _dailyXLabels => List.generate(15, (index) => index.toString()); // 0-14
  List<String> get _weeklyXLabels => ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri']; // Sat-Fri
  List<String> get _monthlyXLabels =>
      List.generate(_getDaysInCurrentMonth(), (index) => (index + 1).toString()); // 1-30/31
  List<String> get _yearlyXLabels =>
      ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']; // Jan-Dec

  // Data for Daily, Weekly, Monthly, Yearly charts
  List<FlSpot> _dailySpots() {
    return List.generate(15, (index) => FlSpot(index.toDouble(), (index % 5 + 1) * 1.5)); // 0 to 14
  }

  List<FlSpot> _weeklySpots() {
    return List.generate(7, (index) => FlSpot(index.toDouble(), (index + 1) * 2.5)); // Sat to Fri
  }

  List<FlSpot> _monthlySpots() {
    final daysInMonth = _getDaysInCurrentMonth();
    return List.generate(daysInMonth, (index) => FlSpot(index.toDouble(), (index % 6 + 1) * 3.0));
  }

  List<FlSpot> _yearlySpots() {
    return List.generate(12, (index) => FlSpot(index.toDouble(), (index + 1) * 150.0)); // Jan to Dec
  }

  // Helper: Get number of days in the current month
  int _getDaysInCurrentMonth() {
    final now = DateTime.now();
    final firstDayNextMonth = DateTime(now.year, now.month + 1, 1);
    final lastDayCurrentMonth = firstDayNextMonth.subtract(Duration(days: 1));
    return lastDayCurrentMonth.day;
  }
}
