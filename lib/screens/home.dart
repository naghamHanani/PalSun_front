import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_back/const/constant.dart';
import 'package:test_back/mainDash.dart';
import 'package:test_back/screens/dashboard.dart';
import 'package:test_back/screens/devices.dart';
import 'package:test_back/screens/plants.dart';
import 'package:test_back/screens/reports.dart';
import 'package:test_back/screens/subPlants.dart';
import 'package:test_back/widgets/custom_card_widget.dart';
import '../data/weather.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../util/ChangeImage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); 
  
  String  user='USER';
  String totalEnergy= '';
  String weatherDescription = 'Loading weather...'; 
  String city = 'Nablus'; 

  final Weather weather = Weather();

  bool _selectedTheme = false;
  List<Widget> theme = <Widget>[
  Icon(FontAwesomeIcons.moon,size: 15),
  Icon(Icons.sunny,size: 15,),
  ];
  

  List<String> notifications = [];  //to store notifications
  int unreadCount = 0;  //unread notifications

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
  socket.on('welcome', (data) {
    print("Received data: $data"); //debugging
    //data' is the message from the server
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
  const url = 'http://localhost:3000/totalEnergy'; 

  try {
    final response = await http.get(Uri.parse(url)); 

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        setState(() {
          totalEnergy = "${data['message']}W"; 
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
  //print('Using context: ${navigatorKey.currentContext}');
  showDialog(
    context: navigatorKey.currentContext!, 
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
                unreadCount = 0; // all notifications as read
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );}


  @override
  void dispose() {
    super.dispose();
    socket.dispose();  // Clean up socket connection when widget is disposed
  }


  @override
  Widget build(BuildContext context) {
 
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: _selectedTheme ? ThemeData.light() : ThemeData.dark(),
      home:Scaffold(
        backgroundColor:_selectedTheme? lightThemeBG: darkThemeBG ,
        key: _scaffoldKey,

        appBar: AppBar(
          backgroundColor:_selectedTheme? lightThemeBG: darkThemeBG,
          leading:
            //menu 
            IconButton(
              icon: 
                Icon(Icons.menu, color:_selectedTheme? darkThemeBG :Colors.white,opticalSize: 30,),
              onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
              },
            ), 
            
            title: Text('                                                            PALSUN' ,style:
                      GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color:_selectedTheme? darkThemeBG :Colors.white,
                      letterSpacing: 5.0)
            ),

            actions: [
              //notifications
              IconButton(
                icon: Stack(
                 children: [
                  Icon(Icons.notifications, color:_selectedTheme? darkThemeBG :Colors.white,opticalSize: 25,),
                  if (unreadCount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.red,
                        child: Text(
                          unreadCount.toString(),
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                ],),
                onPressed: () {
                _showNotificationsDialog();
                },
              ),

            //messages
            IconButton(
              icon: Stack(
                children: [
                  Icon(Icons.message, color:_selectedTheme? darkThemeBG :Colors.white,opticalSize: 30,),
                  if (unreadCount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.red,
                        child: Text(
                          unreadCount.toString(),
                          style: TextStyle(
                            fontSize: 8,
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

            //theme
           ToggleButtons(
            isSelected: [_selectedTheme == false, _selectedTheme == true],
            onPressed: (int index) {
              setState(() {
                _selectedTheme = index == 0 ? false : true;
              });
            },
            color:_selectedTheme? darkThemeBG :Colors.white,
            selectedColor: Colors.yellow,
            fillColor: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0),
            constraints: const BoxConstraints(
              minWidth: 17,
              minHeight: 17,
            ),
              children: theme.map((icon) {
              return Container(
               padding: const EdgeInsets.all(2.0), // Add padding inside the rectangle
               decoration: BoxDecoration(
                color: Colors.transparent, // Background color
                borderRadius: BorderRadius.circular(12.0), ),
                child: SizedBox(
                  height: 16, // Icon size
                  width: 16,
                  child: icon,
                ),
              );
              }).toList(),
            ),

            //profile
            IconButton(
              icon:Icon(Icons.person, color:_selectedTheme? darkThemeBG :Colors.white,opticalSize: 25,),
              onPressed: () {
                _showNotificationsDialog();
              },
            ),

            
           
          ],
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

            // ListTile(
            //   leading: Icon(Icons.link),
            //   title: Text(
            //   'Sub Plants',
            //   style: GoogleFonts.montserrat(
            //   textStyle: TextStyle(
            //     color: Color.fromARGB(255, 29, 63, 90),
            //     fontWeight: FontWeight.w500,
            //     fontSize: 16,
            //   ),
            // ), ),
            //   onTap: () {
            //     // Navigate to Link 2
            //    navigatorKey.currentState?.push(
            //    MaterialPageRoute(builder: (context) => SubPlants()),
            //    ); // Close the drawer
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.link),
            //   title: Text(
            //   'Devices',
            //   style: GoogleFonts.montserrat(
            //   textStyle: TextStyle(
            //     color: Color.fromARGB(255, 29, 63, 90),
            //     fontWeight: FontWeight.w500,
            //     fontSize: 16,
            //   ),
            // ),),
            //   onTap: () {
            //     // Navigate to Link 3
            //    navigatorKey.currentState?.push(
            //    MaterialPageRoute(builder: (context) => Devices()),
            //   ); // Close the drawer
            //   },
            // ),

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

          ],
        ),
      ),

      body: Scaffold(
        backgroundColor: _selectedTheme? lightThemeBG: darkThemeBG,
        body: SingleChildScrollView(
        child: Column(
          
          children: [
           
            SizedBox(
              height:400,
              child: RotatingImageWidget(user: user), 
            ),

            SizedBox(
              height:40
            ), 

            Padding(
              padding: const EdgeInsets.only(left:40.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width:900,
                    height:300,
                    child: Container(
                    color:_selectedTheme? const Color.fromARGB(255, 6, 70, 121): const Color.fromARGB(255, 119, 176, 222),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                         Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          // Title
                         Text(
                         ' Get Updated On Plant Performance Overview',
                         style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                          color: _selectedTheme? Color.fromARGB(255, 243, 239, 239): darkThemeBG,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                            ),),
                          ),
                  
                          SizedBox(height: 30), // Space between title and paragraph
                          // Paragraph
                           Text(
                           'Get updated on your plants’ performance with real-time data. '
                           'Our tools provide insights to help you track growth, identify trends, '
                           'and make data-driven decisions.',
                            style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                             color: _selectedTheme? Color.fromARGB(255, 243, 239, 239): darkThemeBG,
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0, // Smaller font size for paragraph
                              ), ),
                          ),
                         ],
                          ),
                         ),
                  
                         SizedBox(width: 20), // Space between text and icon
                         // Icon section
                        InkWell(
  onTap: () {
    // Navigate to the desired page
    navigatorKey.currentState?.push(
                 MaterialPageRoute(builder: (context) => MyApp()),
                );
  },
  child: Image.asset(
    'assets/images/arrow.png', // Path to your image
    width: 90.0,                // Set the width of the image
    height: 90.0,               // Set the height of the image
  ),
)
                        ],
                      ),
                     ),),),
                ],
              ),
            ),


            SizedBox(height:60),

            Padding(
              padding: const EdgeInsets.only(right:40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                   SizedBox(
                      width:900,
                      height:300,
                     child: Container(
                      color: const Color.fromARGB(255, 6, 70, 121),
                        
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: Text(
                                       '          Get updated on ypur plants performance',
                                       style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            
                            color: Color.fromARGB(255, 243, 239, 239),
                            fontWeight: FontWeight.w500,
                            fontSize: 24.0,
                          )
                                       )
                                     ),
                       ),
                     ),
                   )
                   ],
              ),
            ),
           
            SizedBox(height:100),

             Padding(
              padding: const EdgeInsets.only(right:0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                   SizedBox(
                      
                     child: Container(
                      
                      color: const Color.fromARGB(255, 6, 70, 121),
                        
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: Text(
                                       '       Abous us',
                                       style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            
                            color: Color.fromARGB(255, 243, 239, 239),
                            fontWeight: FontWeight.w500,
                            fontSize: 24.0,
                          )
                                       )
                                     ),
                       ),
                     ),
                   )
                   ],
              ),
            ),
        ])

      ),
    )
    )
    );
  }
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
    return Icons.wb_cloudy; 
  }
}