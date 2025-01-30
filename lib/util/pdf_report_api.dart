import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:test_back/data/reports_chart_data.dart';
import 'package:test_back/screens/reports.dart';
import 'package:test_back/util/pdf_table_data.dart';


class PdfReportApi {
  static Future<List<int>> generate(
    int tabIndex,
    String reportTitle,
    List<String> cardData,

    List<Map<String, String>> chartData, // Chart data in {x: "value", y: "value"} format



  ) async {


    // Fetch data from backend based on selected tab
  List<Map<String, String>> chartData = await fetchPVData(
    tabIndex == 0 ? "daily" :
    tabIndex == 1 ? "weekly" :
    tabIndex == 2 ? "monthly" : "yearly",
  );

  
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
  
  List<Map<String, String>> rawChartData = await fetchPVData(
      tabIndex == 0 ? "daily" :
      tabIndex == 1 ? "weekly" :
      tabIndex == 2 ? "monthly" : "yearly",
    );
List<Map<String, String>> processChartData(List<Map<String, String>> rawData, int tabIndex) {
  // To store aggregated sums by key (hour, day, month)
  Map<String, double> aggregatedData = {};

  // Initialize the keys for all units (hours, days, months) only if there is data
  List<String> keys = [];

  switch (tabIndex) {
    case 0: // Daily: Use the hour of the day as the key (last 24 hours)
      for (int i = 0; i < 24; i++) {
        // Generate all 24 hours as keys (e.g., "2025-01-30 00", "2025-01-30 01", ..., "2025-01-30 23")
        String hourKey = DateFormat('yyyy-MM-dd').format(DateTime.now()) + " ${i.toString().padLeft(2, '0')}";
        keys.add(hourKey);
      }
      break;
    case 1: // Weekly: Use the day of the week as the key (last 7 days)
      keys = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      break;
    case 2: // Monthly: Use the day of the month as the key (last 29 days)
      for (int i = 1; i <= 29; i++) {
        keys.add(i.toString());
      }
      break;
    case 3: // Yearly: Use the month name as the key (last 12 months)
      keys = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      break;
    default:
      throw Exception("Invalid tab index");
  }

  // Aggregate the data by key
  for (var entry in rawData) {
    String xValue = entry["x"]!;  // The "x" value (time in string format)
    double yValue = double.parse(entry["y"]!);  // The "y" value (which we will sum)

    String key;

    // Extract the appropriate time unit based on tabIndex
    switch (tabIndex) {
      case 0: // Daily: Use the hour of the day as the key
        DateTime dateTime = DateTime.parse(xValue);
        key = DateFormat('yyyy-MM-dd HH').format(dateTime); // Group by hour of the day
        break;
      case 1: // Weekly: Use the day of the week as the key
        DateTime dateTime = DateTime.parse(xValue);
        key = DateFormat('EEEE').format(dateTime); // Group by day of the week
        break;
      case 2: // Monthly: Use the day of the month as the key
        DateTime dateTime = DateTime.parse(xValue);
        key = DateFormat('d').format(dateTime); // Group by day of the month
        break;
      case 3: // Yearly: Use the month name as the key
        DateTime dateTime = DateTime.parse(xValue);
        key = DateFormat('MMMM').format(dateTime); // Group by month of the year
        break;
      default:
        throw Exception("Invalid tab index");
    }

    // Aggregate the y values by key (time unit)
    if (aggregatedData.containsKey(key)) {
      aggregatedData[key] = aggregatedData[key]! + yValue;  // Summing up the y values
    } else {
      aggregatedData[key] = yValue;  // Initialize with the first value
    }
  }

  // Now we filter out the keys with no data (values > 0)
  aggregatedData.removeWhere((key, value) => value == 0);

  // Convert the aggregated data into a list of maps for the table
  List<Map<String, String>> result = aggregatedData.entries.map((entry) {
    return {"x": entry.key, "y": entry.value.toStringAsFixed(2)};
  }).toList();

  return result;
}



  List<Map<String, String>> processedData = processChartData(chartData, tabIndex);
final tableData = List.generate(processedData.length, (index) {
      // Check if processedData has an entry for this index
      if (index < bottomTitles.length) {
        // Return both bottom title and corresponding y value from processed data
        return [bottomTitles[index] ?? '', processedData[index]['y'] ?? ''];
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


  // New method to process the chart data (aggregation based on time unit)
  static List<Map<String, String>> processChartData(List<Map<String, String>> rawData, int tabIndex) {
    Map<String, double> aggregatedData = {}; // To store aggregated sums

    for (var entry in rawData) {
      String xValue = entry["x"]!;  // The "x" value (time in string format)
      double yValue = double.parse(entry["y"]!);  // The "y" value (which we will sum)

      String key;

      // Extract the appropriate time unit based on tabIndex
      switch (tabIndex) {
        case 0: // Daily: Use the hour of the day as the key
          key = DateFormat('yyyy-MM-dd HH').format(DateTime.parse(xValue)); // "2025-01-30 12"
          break;
        case 1: // Weekly: Use the day of the week as the key
          key = DateFormat('EEEE').format(DateTime.parse(xValue)); // "Monday", "Tuesday", ...
          break;
        case 2: // Monthly: Use the day of the month as the key
          key = DateFormat('d').format(DateTime.parse(xValue)); // "1", "2", ...
          break;
        case 3: // Yearly: Use the month name as the key
          key = DateFormat('MMMM').format(DateTime.parse(xValue)); // "January", "February", ...
          break;
        default:
          throw Exception("Invalid tab index");
      }

      // Aggregate the y values by key (time unit)
      if (aggregatedData.containsKey(key)) {
        aggregatedData[key] = aggregatedData[key]! + yValue;  // Summing up the y values
      } else {
        aggregatedData[key] = yValue;  // Initialize with the first value
      }
    }

    // Convert the aggregated data into a list of maps for the table
    List<Map<String, String>> result = aggregatedData.entries.map((entry) {
      return {"x": entry.key, "y": entry.value.toStringAsFixed(2)};
    }).toList();

    return result;
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