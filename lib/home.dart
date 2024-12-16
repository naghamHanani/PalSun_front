import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather.dart';


//import 'package:fl_chart/fl_chart.dart';


 void main() {
   runApp(const HomePage());
 }
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String  user='USER';
  String totalEnergy= '200W';

  String weatherDescription = 'Loading weather...'; 
  String city = 'Nablus'; 
 final Weather weather = Weather();

 // static const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

 @override
  void initState() {
    super.initState();
    _fetchWeather(); // Fetch weather on initialization
  }

  void _fetchWeather() async {
    try {

      final weatherData = await weather.fetchWeather(city);

      setState(() {
        weatherDescription =
            "Temp: ${weatherData['current']['temp_c']}°C, ${weatherData['current']['condition']['text']}";
      });
    } catch (e) {
      setState(() {
        weatherDescription = 'Failed to load weather';
      });
    }
  }



  @override
  Widget build(BuildContext context) {
 
    return  MaterialApp(
      home:Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 29, 63, 90),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png', 
            fit: BoxFit.contain,
          ),
        ),
         title: TextField(
    controller: _searchController,
    decoration: const InputDecoration(
      hintText: 'Search...',
      hintStyle: TextStyle(color: Colors.white54),
      border: InputBorder.none,
    ),
    style: const TextStyle(color: Colors.white),
    onSubmitted: (value) {
      // Handle search logic
      print('Search query: $value');
    },
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.search, color: Colors.white),
      onPressed: () {
        // Handle search icon press
        print('Search query: ${_searchController.text}');
      },
    ),
  ],

      ),

      body:  SingleChildScrollView( // To allow scrolling when there are multiple widgets
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
             Stack( 
             
              children: [
        
                   Container(
              alignment: Alignment.center, 
                   child: Image.asset( 
                   'assets/images/uni.png', 
                   height: 200, 
                   width: double.infinity, 
                   fit: BoxFit.cover, 
                      ), 
                  ), 


             Container( 
                   alignment: FractionalOffset(0.8, 0.7), 
                   child: Text( 
                  'HELLO $user', 
                    style: GoogleFonts.montserrat(
                       textStyle: TextStyle(color: const Color.fromARGB(255, 243, 239, 239), 
                      // fontWeight: FontWeight.bold, 
                       fontWeight: FontWeight.w500,
                       fontSize: 24.0,
                      ), 
                    )
                    ), )
              ]),
              
             Padding(
          padding: const EdgeInsets.all(16.0),  // Padding around the body content
          child:Column(children: [ 
              SizedBox(height: 30,),
             
              Card(
                  //elevation: 5,
                  //margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    leading: Icon(Icons.analytics, color: Color.fromARGB(255, 29, 63, 90)),
                    title: Text(
                      "Today's total energy ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(totalEnergy),
                    trailing: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 29, 63, 90)),
                    onTap: () {
                      // Handle tap event (optional)
                      print("Revenue Widget tapped");
                    },
                  ),
                ),
                SizedBox(height: 15,),



                Card(
                      child: ListTile(
                        leading:  Icon(
                          _getWeatherIcon(weatherDescription),
                            color: Color.fromARGB(255, 29, 63, 90)),
                        title: const Text(
                          "Today's weather",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(weatherDescription), // Display weather
                        //trailing: const Icon(Icons.arrow_forward,
                           // color: Color.fromARGB(255, 29, 63, 90)),
                        onTap: () {
                          print("Weather Widget tapped");
                        },
                      ),
                    ),
              
             


                SizedBox(height: 30,),

                SfCartesianChart(
                  
                  // Initialize category axis
                  primaryXAxis: CategoryAxis(),
                
                  series: <LineSeries<SalesData, String>>[
                    LineSeries<SalesData, String>(
                      // Bind data source
                      dataSource:  <SalesData>[
                        SalesData('Jan', 35),
                        SalesData('Feb', 28),
                        SalesData('Mar', 34),
                        SalesData('Apr', 32),
                        SalesData('May', 40)
                      ],
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales
                    )
                  ]
                ),
                ],)
             
            ),
          ],)
      ),
      )
    );
  }
}
class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
IconData _getWeatherIcon(String condition) {
  if (condition.toLowerCase().contains('sun')) {
    return Icons.wb_sunny;
  } else if (condition.toLowerCase().contains('cloud')) {
    return Icons.cloud;
  } else if (condition.toLowerCase().contains('rain')) {
    return Icons.grain;
  } else if (condition.toLowerCase().contains('snow')) {
    return Icons.ac_unit;
  } else {
    return Icons.wb_cloudy; // Default
  }
}