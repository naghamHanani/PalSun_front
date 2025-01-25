import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RotatingImageWidget extends StatefulWidget {
  final String user; // Pass the user's name
  const RotatingImageWidget({super.key, required this.user});

  @override
  _RotatingImageWidgetState createState() => _RotatingImageWidgetState();
}

class _RotatingImageWidgetState extends State<RotatingImageWidget> {
  // List of images to display
  final List<String> images = [
    //'assets/images/hello.png',
    //'assets/images/home.png',
    'assets/images/uni.png',
    'assets/images/uni_1.jpg',
    'assets/images/uni_2.jpg',
    //'assets/images/uni_3.jpg',
    //'assets/images/picture3.png',
  ];

  int currentImageIndex = 0; // Track the current image index
  late Timer timer; // Timer to handle image rotation

  @override
  void initState() {
    super.initState();

    // Start the timer to change the image every 30 seconds
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        currentImageIndex = (currentImageIndex + 1) % images.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
        children: [
          // Background image with smooth fade transition
          AnimatedSwitcher(
            duration: Duration(seconds: 1), // Transition duration
            switchInCurve: Curves.easeInOut, // Animation curve for entering
            switchOutCurve: Curves.easeInOut, // Animation curve for exiting
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Container(
              key: ValueKey<int>(currentImageIndex), // Unique key for each image
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(images[currentImageIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      
          // Overlay text
          

          
            
             Container(
              // color: Color.fromARGB(255, 12, 37, 58),
              
                 child: Align(
                  alignment: FractionalOffset(0.9, 0.1),
                  child:Text(
                'Welcome to PalSun, \n ${widget.user}',
                
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    
                    color: Color.fromARGB(255, 243, 239, 239),
                    fontWeight: FontWeight.w500,
                    fontSize: 24.0,
                    shadows: [
                  Shadow(
                  offset: Offset(1.0, 1.0), // Horizontal and vertical offset
                blurRadius: 8.0,          // How blurry the shadow is
                color: Color.fromARGB(128, 6, 1, 67).withOpacity(0.9), // Shadow color with opacity
                 ),
                   ],
                  ),
                ),
                  ),
              )
            ),
          
        ],
      
    );
  }
}
