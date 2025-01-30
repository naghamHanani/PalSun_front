import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_back/const/constant.dart';
import 'package:test_back/data/reports_cards_data.dart';
import 'package:test_back/mainDash.dart';
import 'package:test_back/models/health_model.dart';
import 'package:test_back/screens/home.dart';
import 'package:test_back/screens/plants.dart';
import 'package:test_back/util/responsive.dart';
import 'package:test_back/widgets/custom_card_widget.dart';
import '../data/reports_chart_data.dart';
import 'package:printing/printing.dart';
import '../util/pdf_report_api.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); 
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final reportsCardsData = ReportsCardsData();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // 4 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<HealthModel> getCardsDataForTab(int tabIndex) {
    switch (tabIndex) {
      case 0: // Daily
        return reportsCardsData.dailyCardsData;
      case 1: // Weekly
        return reportsCardsData.weeklyCardsData;
      case 2: // Monthly
        return reportsCardsData.monthlyCardsData;
      case 3: // Yearly
        return reportsCardsData.yearlyCardsData;
      default:
        return reportsCardsData.dailyCardsData;
    }
  }
  ChartData getChartDataForTab(int tabIndex) {
    switch (tabIndex) {
      case 0: // Daily
        return ChartData(spots: reportChartData().daySpots, bottomTitle: reportChartData().dayBottomTitle, leftTitle: reportChartData().dayLeftTitle);
      case 1: // Weekly
        return ChartData(spots: reportChartData().weekSpots, bottomTitle: reportChartData().weekBottomTitle, leftTitle: reportChartData().weekLeftTitle);

      case 2: // Monthly
        return ChartData(spots: reportChartData().monthSpots, bottomTitle: reportChartData().monthBottomTitle, leftTitle: reportChartData().monthLeftTitle);

      case 3: // Yearly
         return ChartData(spots: reportChartData().yearSpots, bottomTitle: reportChartData().yearBottomTitle, leftTitle: reportChartData().yearLeftTitle);

      default:
        return ChartData(spots: reportChartData().daySpots, bottomTitle: reportChartData().dayBottomTitle, leftTitle: reportChartData().dayLeftTitle);

    }
  }

  @override
  Widget build(BuildContext context) {

    final data = reportChartData();
    
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home:Scaffold(
      key: _scaffoldKey,
      backgroundColor: darkThemeBG,
      appBar: AppBar(
        backgroundColor: darkThemeBG,
        leading:
            //menu 
            IconButton(
              icon: 
                Icon(Icons.menu, color:Colors.white,opticalSize: 30,),
              onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
              },
            ),
        title: Text('                                                            PALSUN' ,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 5.0,
          ),
        ),
        actions:[
          TextButton(
            child: Text('Generate PDF'),
            onPressed: () async{
              // Fetch the current tab index
              final tabIndex = _tabController.index;

              // Generate the content for the current tab
              final reportTitle =
                  '${['Daily', 'Weekly', 'Monthly', 'Yearly'][tabIndex]} Report';


              final cardData = getCardsDataForTab(tabIndex)
                  .map((card) => '${card.title}: ${card.value}')
                  .toList();

              final chartData = getChartDataForTab(tabIndex).spots
                  .map((spot) => {'x': spot.x.toString(), 'y': spot.y.toString()})
                  .toList();

                // Reduce the data by picking the 1st, 5th, 10th, etc.
                      final reducedChartData = List.generate(
                  (chartData.length /10).ceil(), // Generate data for every 5th point
                      (index) => chartData[index * 10], // Take every 5th element
                      );
              // Generate the PDF file
              final pdfData = await PdfReportApi.generate(
                tabIndex,
                reportTitle,
                cardData,
                reducedChartData,
              );

              // Display the PDF using the Printing package
                final pdfUint8List = Uint8List.fromList(pdfData);
              await Printing.layoutPdf(onLayout: (format) async =>pdfUint8List);
            }, 
            )
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {}); // Trigger UI update when tab changes
          },
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
          ],
          indicatorColor: const Color.fromARGB(255, 3, 176, 192),
        ),
      ),

      drawer: Drawer(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,),
          backgroundColor: selectionColor,
          child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 12, 37, 58),
              ),
              child: Text(
                'Menu',
                style: GoogleFonts.montserrat(
                   textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ), )
              ),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart,color:darkThemeBG),
              title: Text(
               'Reports',
               style: GoogleFonts.montserrat(
               textStyle: TextStyle(
                color: Color.fromARGB(255, 29, 63, 90),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
               ), ),
              onTap: () {
                // Navigate to Link 3
                navigatorKey.currentState?.push(
                 MaterialPageRoute(builder: (context) => Reports(
                  
                 )),
                 ); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.home,color:darkThemeBG),
              title: Text(
               'Home',
               style: GoogleFonts.montserrat(
               textStyle: TextStyle(
                color: Color.fromARGB(255, 29, 63, 90),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
               ), ),
              onTap: () {
                // Navigate to Link 3
                navigatorKey.currentState?.push(
                 MaterialPageRoute(builder: (context) => HomePage(
                  
                 )),
                 ); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics ,color:darkThemeBG),
              title: Text(
              'Dashboard',
              style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 29, 63, 90),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              ), ),
              onTap: () {
                // Navigate to Link 3
                navigatorKey.currentState?.push(
                 MaterialPageRoute(builder: (context) => MyApp()),
                ); // Close the drawer
              },
            ),

            ListTile(
              leading: Icon(Icons.eco,color:darkThemeBG),
              title: Text(
              'Plants',
              style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 29, 63, 90),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              ), ),
              onTap: () {
                // Navigate to Link 1
              navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => Plants()),
              );
              },
            ),
             

          ],
        ),
      ),









      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChart('Daily Report', data.daySpots, data.dayBottomTitle, data.dayLeftTitle),
          _buildChart('Weekly Report', data.weekSpots, data.weekBottomTitle, data.weekLeftTitle),
          _buildChart('Monthly Report', data.monthSpots, data.monthBottomTitle, data.monthLeftTitle),
          _buildChart('Yearly Report', data.yearSpots, data.yearBottomTitle, data.yearLeftTitle),
        ],
      ),)
    );
  }

  Widget _buildChart(String title, List<FlSpot> spots, Map<int, String> bottomTitle, Map<int, String> leftTitle) {
    final tabIndex = _tabController.index; // Get current tab index
    final cardData = getCardsDataForTab(tabIndex); // Get cards data for the current tab

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title for the chart
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Chart Container
        Container(
          height: 400, // Set a fixed height for the chart
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(handleBuiltInTouches: true),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return bottomTitle[value.toInt()] != null
                          ? SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                bottomTitle[value.toInt()].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20,
                    reservedSize: 40,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return leftTitle[value.toInt()] != null
                          ? Text(
                              leftTitle[value.toInt()].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  color: const Color.fromARGB(255, 21, 208, 218),
                  barWidth: 2.5,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 21, 208, 218).withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  dotData: FlDotData(show: false),
                ),
              ],
              minX: spots.isEmpty ? 0 : spots.first.x,
              maxX: spots.isEmpty ? 0 : spots.last.x,
              minY: 0,
              maxY: spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 10,
            ),
          ),
        ),

         SizedBox(height:30),



          // Cards Section
          GridView.builder(
            itemCount: cardData.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
              crossAxisSpacing: Responsive.isMobile(context) ? 12 : 15,
              mainAxisSpacing: 12.0,
            ),
            itemBuilder: (context, index) => CustomCard(
              color: const Color.fromARGB(255, 12, 125, 131),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(cardData[index].icon, size: 30),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 4),
                    child: Text(
                      cardData[index].value,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    cardData[index].title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
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

    //      Padding(
    //         padding: const EdgeInsets.all(0.0),
    //         child: Column(
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 Card(
                  
    //               color: const Color.fromARGB(255, 14, 139, 146),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               child: Container(
    //                 constraints: BoxConstraints(
    //   minWidth: 300, // Minimum width of the card
    //   minHeight: 300, // Minimum height of the card
    // ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       SizedBox(height: 10,),
    //                       Icon(Icons.bar_chart, color: Colors.white),
    //                       SizedBox(height: 10,),
    //                       Text(
    //                         'Card 2',
    //                         style: const TextStyle(color: Colors.white,fontSize: 14),
    //                       ),
    //                       SizedBox(height: 10,),
    //                       Text(
    //                         'THE VALUEE 22992929',
    //                         style: const TextStyle(color: Colors.white),
    //                       ),
                          
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),


    //               Card(
                  
    //               color: const Color.fromARGB(255, 14, 139, 146),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               child: Container(
    //                 constraints: BoxConstraints(
    //   minWidth: 300, // Minimum width of the card
    //   minHeight: 300, // Minimum height of the card
    // ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       SizedBox(height: 10,),
    //                       Icon(Icons.bar_chart, color: Colors.white),
    //                       SizedBox(height: 10,),
    //                       Text(
    //                         'Card 2',
    //                         style: const TextStyle(color: Colors.white,fontSize: 14),
    //                       ),
    //                       SizedBox(height: 10,),
    //                       Text(
    //                         'THE VALUEE 22992929',
    //                         style: const TextStyle(color: Colors.white),
    //                       ),
                          
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //               //SizedBox(width:30),


    //               Card(
                  
    //               color: const Color.fromARGB(255, 14, 139, 146),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               child: Container(
    //                 constraints: BoxConstraints(
    //   minWidth: 300, // Minimum width of the card
    //   minHeight: 300, // Minimum height of the card
    // ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       SizedBox(height: 10,),
    //                       Icon(Icons.bar_chart, color: Colors.white),
    //                       SizedBox(height: 10,),
    //                       Text(
    //                         'Card 2',
    //                         style: const TextStyle(color: Colors.white,fontSize: 14),
    //                       ),
    //                       SizedBox(height: 10,),
    //                       Text(
    //                         'THE VALUEE 22992929',
    //                         style: const TextStyle(color: Colors.white),
    //                       ),
                          
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),


    //            // SizedBox(width:30),


    //             Card(
                  
    //               color: const Color.fromARGB(255, 14, 139, 146),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(16),
    //               ),
    //               child: Container(
    //                 constraints: BoxConstraints(
    //   minWidth: 300, // Minimum width of the card
    //   minHeight: 300, // Minimum height of the card
    // ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       SizedBox(width:10),
    //                       Icon(Icons.bar_chart, color: Colors.white),
    //                       SizedBox(width:10),
    //                       Text(
    //                         'Card 2',
    //                         style: const TextStyle(color: Colors.white,fontSize: 14),
    //                       ),
    //                       SizedBox(width:15),
    //                       Text(
    //                         'THE VALUEE 22992929',
    //                         style: const TextStyle(color: Colors.white),
    //                       ),
                          
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //               ],
    //             ),
    //             const SizedBox(height: 8),
               
    //           ],
    //         ),
    //       ),
        




  // Data Models for Charts
//   final _dailyData = ChartData(
//     spots: List.generate(15, (index) => FlSpot(index.toDouble(), (index % 5 + 1) * 1.5)),
//     leftTitle: {0: '0', 5: '5', 10: '10', 15: '15'},
//     bottomTitle: {0: '0', 5: '5am', 10: '10am', 15: '3pm'},
//     minY: 0,
//     maxY: 15,
//   );

//   final _weeklyData = ChartData(
//     spots: List.generate(7, (index) => FlSpot(index.toDouble(), (index + 1) * 2.5)),
//     leftTitle: {0: '0', 10: '10', 20: '20'},
//     bottomTitle: {0: 'Sat', 1: 'Sun', 2: 'Mon', 3: 'Tue', 4: 'Wed', 5: 'Thu', 6: 'Fri'},
//     minY: 0,
//     maxY: 20,
//   );

//   final _monthlyData = ChartData(
//     spots: List.generate(31, (index) => FlSpot(index.toDouble(), (index % 6 + 1) * 3.0)),
//     leftTitle: {0: '0', 20: '20', 40: '40'},
//     bottomTitle: Map.fromEntries(List.generate(31, (index) => MapEntry(index, (index + 1).toString()))),
//     minY: 0,
//     maxY: 40,
//   );

//   final _yearlyData = ChartData(
//     spots: List.generate(12, (index) => FlSpot(index.toDouble(), (index + 1) * 150.0)),
//     leftTitle: {0: '0', 500: '500', 1500: '1500'},
//     bottomTitle: {0: 'Jan', 1: 'Feb', 2: 'Mar', 3: 'Apr', 4: 'May', 5: 'Jun', 6: 'Jul', 7: 'Aug', 8: 'Sep', 9: 'Oct', 10: 'Nov', 11: 'Dec'},
//     minY: 0,
//     maxY: 1500,
//   );
// }

// class ChartData {
//   final List<FlSpot> spots;
//   final Map<int, String> leftTitle;
//   final Map<int, String> bottomTitle;
//   final double minY;
//   final double maxY;

//   ChartData({
//     required this.spots,
//     required this.leftTitle,
//     required this.bottomTitle,
//     required this.minY,
//     required this.maxY,
//   });
//}
class ChartData {
  final List<FlSpot> spots;
  final Map<int, String> bottomTitle;
  final Map<int, String> leftTitle;

  ChartData({
    required this.spots,
    required this.bottomTitle,
    required this.leftTitle,
  });
}
