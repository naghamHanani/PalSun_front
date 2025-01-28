import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_back/data/reports_chart_data.dart';
import 'package:test_back/screens/reports.dart';


class PdfReportApi {
  static Future<List<int>> generate(
    int tabIndex,
    String reportTitle,
    List<String> cardData,

    List<Map<String, String>> chartData, // Chart data in {x: "value", y: "value"} format
  ) async {
    final pdf = pw.Document();
    print('before image loading');
    final logoData = await _getLogoData();
    print('after image loading');
     final currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    
     // Generate the chart image
    //final chartImage = await _generateChartImage(chartData);

    // Fetch the bottom titles for the chart based on tabIndex
  final chartDataForTab = getChartDataForTab(tabIndex);
  final bottomTitles = chartDataForTab.bottomTitle;
  
  // Create a table using bottom titles as the x-axis
  // final tableData = chartData.map((dataPoint) {
  //   final xIndex = chartData.indexOf(dataPoint); // Find the index of the spot
  //   return [bottomTitles[xIndex] ?? '',]; // Use bottom title instead of x value
  // }).toList();

  final tableData = List.generate(chartData.length, (index) {
  // Check if bottomTitles has an entry for this index
  if (index < bottomTitles.length) {
    // Return both bottom title and corresponding y value from chartData
    return [bottomTitles[index] ?? '', chartData[index]['y'] ?? '']; 
  } else {
    // If no corresponding bottom title, return empty values
    return ['', ''];
  }
});

  if (tableData.isEmpty) {
  print('No data available for the table.');
} else {
  print('Table data exists: $tableData');
}

    // Add the logo and report title at the top
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
                  pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(
                  pw.MemoryImage(logoData), // Load logo as bytes
                  width: 90,
                  height: 90,
                ),
                pw.Text(
                  "PalSun Portal",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
                pw.Text(
                  currentDate,
                  style: pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
              //pw.Image(pw.MemoryImage(logoData)), // Add logo
              pw.SizedBox(height: 30),
              pw.Text(
                reportTitle,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              
              // Add the chart data section (as a table)
              pw.Text('Total PV generation:', style: pw.TextStyle(fontSize: 18)),
              
               pw.SizedBox(height: 20),

              pw.TableHelper.fromTextArray(
                  headers: ['X', 'Y'],  // Table headers
                  data:tableData,
                  // chartData
                  //     .map((dataPoint) => [dataPoint['x'] ?? '', dataPoint['y'] ?? ''])  // Format each row
                  //     .toList(),
                ),
              
              
               //pw.Image(pw.MemoryImage(chartImage), width: 300, height: 200),
              pw.SizedBox(height: 20),

              // Add cards data section
              pw.Text('Total values:', style: pw.TextStyle(fontSize: 18)),
              pw.ListView(
                children: cardData.map((card) {
                  return pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Text(card),
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );
    // Return the generated PDF as a list of bytes
    return pdf.save();
  }

  // Helper method to load the logo image (replace with actual image asset)
  static Future<Uint8List> _getLogoData() async {
    final byteData = await rootBundle.load('assets/images/logo.png');
     return byteData.buffer.asUint8List();
   // return byteData.buffer.asUint8List();
  }




   // Helper method to generate the chart as an image
  // static Future<Uint8List> _generateChartImage(List<Map<String, String>> chartData) async {

  //   final dataPoints = chartData.map((point) {
  //     return FlSpot(
  //       double.parse(point['x'] ?? '0'),
  //       double.parse(point['y'] ?? '0'),
  //     );
  //   }).toList();

  //   // Create the chart widget
  //   final chart = LineChart(
  //     LineChartData(
  //       gridData: FlGridData(show: false),
  //       titlesData: FlTitlesData(show: true),
  //       borderData: FlBorderData(show: true),
  //       lineBarsData: [
  //         LineChartBarData(
  //           spots: dataPoints,
  //           isCurved: true,
  //           color:Colors.blue,
  //           barWidth: 4,
  //           belowBarData: BarAreaData(show: false),
  //         ),
  //       ],
  //     ),
  //   );

  //   // Create a RepaintBoundary to capture the chart widget as an image
  //   final boundary = RepaintBoundary();
  //   final chartWidget = MaterialApp(
  //     home: Scaffold(
  //       body: RepaintBoundary(child: chart),
  //     ),
  //   );

  //   // Render the widget to an image
  //   final boundaryRender = boundary.createRenderObject(chartWidget as BuildContext);
  //   final image = await boundaryRender.toImage(pixelRatio: 3.0);
  //   final byteData = await image.toByteData(format: ImageByteFormat.png); // Correct import
  //   return byteData!.buffer.asUint8List();
  // }




  static ChartData getChartDataForTab(int tabIndex) {
  switch (tabIndex) {
    case 0: // Daily
      return ChartData(
        spots: reportChartData().daySpots,
        bottomTitle: reportChartData().dayBottomTitle, 
        leftTitle: reportChartData().dayLeftTitle
      );
    case 1: // Weekly
      return ChartData(
        spots: reportChartData().weekSpots,
        bottomTitle: reportChartData().weekBottomTitle, 
        leftTitle: reportChartData().weekLeftTitle
      );
    case 2: // Monthly
      return ChartData(
        spots: reportChartData().monthSpots,
        bottomTitle: reportChartData().monthBottomTitle, 
        leftTitle: reportChartData().monthLeftTitle
      );
    case 3: // Yearly
      return ChartData(
        spots: reportChartData().yearSpots,
        bottomTitle: reportChartData().yearBottomTitle, 
        leftTitle: reportChartData().yearLeftTitle
      );
    default:
      return ChartData(
        spots: reportChartData().daySpots,
        bottomTitle: reportChartData().dayBottomTitle, 
        leftTitle: reportChartData().dayLeftTitle
      );
  }
}
}