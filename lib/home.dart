import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather.dart';
import 'dart:convert'; // For decoding JSON
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String  user='USER';
  String totalEnergy= '';

  String weatherDescription = 'Loading weather...'; 
  String city = 'Nablus'; 
 final Weather weather = Weather();

 // static const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

   // New variables for notification management
  List<String> notifications = [];  // List to store notifications
  int unreadCount = 0;  // Number of unread notifications
  late IO.Socket socket;  // Socket connection

 @override
  void initState() {
    super.initState();
    _fetchWeather(); // Fetch weather on initialization
    _fetchTotalEnergy(); // Fetch total energy on initialization
    _connectSocket();  // Set up the socket connection to listen for notifications
  }

  // Connect to the Socket.io server
  void _connectSocket() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

  socket.connect();

    // Listen for the 'welcome' event and handle the received message
    socket.on('welcome', (data) {
      print("Received data: $data"); // For debugging

      // Assuming 'data' is the message from the server
      if (data != null) {
        setState(() {
          notifications.add(data);  // Add the message to the notifications list
          unreadCount++;  // Increment unread count
        });
      }
    });

    socket.on('errorDetected', (data) {
      // Handle the incoming error notification
      setState(() {
        notifications.add(data['message']);
        unreadCount++;
      });
    });
  }

  // Fetch weather data
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

  void _fetchTotalEnergy() async {
  const url = 'http://localhost:3000/totalEnergy'; // Replace with your actual backend URL

  try {
    final response = await http.get(Uri.parse(url)); // Ensure you import `package:http/http.dart` as http.

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        setState(() {
          totalEnergy = "${data['message']}W"; // Update `totalEnergy` with the backend response
          //print(totalEnergy);
        });
      } else {
        setState(() {
          totalEnergy = 'Error fetching energy';
        });
      }
    } else {
      setState(() {
        totalEnergy = 'Error: ${response.statusCode}';
      });
    }
  } catch (e) {
    setState(() {
      totalEnergy = 'Failed to connect to server';
    });
  }
 }

 void _showNotificationsDialog() {
   print('Using context: ${navigatorKey.currentContext}');
  showDialog(
    context: navigatorKey.currentContext!, // Use the navigatorKey context
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Notifications'),
        content: SizedBox(
          height: 200,
          width: 300,
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notifications[index]),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              setState(() {
                unreadCount = 0; // Mark all notifications as read
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
 

  @override
  void dispose() {
    super.dispose();
    socket.dispose();  // Clean up socket connection when widget is disposed
  }


  @override
  Widget build(BuildContext context) {
 
    return  MaterialApp(
      navigatorKey: navigatorKey,
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
              print('Search query: $value');
            },
          ),
          actions: [
            IconButton(
              icon: Stack(
                children: [
                  Icon(Icons.notifications, color: Colors.white),
                  if (unreadCount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          unreadCount.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                ],
              ),
              onPressed: () {
                _showNotificationsDialog();
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