

import 'package:flutter/material.dart';

class Responsive {

  static bool isMobile (BuildContext context) =>
    MediaQuery.of(context).size.width < 850 ; //screen width is less than 850 pixels
    //itll be true if its a mobile

  static bool isTablet (BuildContext context) =>
    MediaQuery.of(context).size.width < 1100 &&
    MediaQuery.of(context).size.width >= 850 ; 

  static bool isDesktop (BuildContext context) =>
    MediaQuery.of(context).size.width >= 1100;
}