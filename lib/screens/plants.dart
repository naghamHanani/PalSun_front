import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_back/const/constant.dart';
import 'package:test_back/mainDash.dart';
import 'package:test_back/screens/home.dart';
import 'package:test_back/screens/reports.dart';

class Plants extends StatefulWidget {
  const Plants({super.key});
  
  @override
  State<Plants> createState() => _PlantsState();
}

class _PlantsState extends State<Plants> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); 
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
              leading: Icon(Icons.bar_chart,color:darkThemeBG),
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
      ),
      
    );
  }
}