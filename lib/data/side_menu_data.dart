
import 'package:test_back/mainDash.dart';
import 'package:test_back/models/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:test_back/screens/home.dart';
import 'package:test_back/screens/plants.dart';
import 'package:test_back/screens/profile.dart';
import 'package:test_back/screens/reports.dart';


class SideMenuData {
  final menu =  <MenuModel>[
    
    MenuModel(icon: Icons.analytics, title:'Dashboard',page :MyApp()),
    MenuModel(icon: Icons.home, title:'Home',page :HomePage()),
    MenuModel(icon: Icons.person, title:'Profile',page: Profile()),
    MenuModel(icon: Icons.eco, title:'Plants',page : Plants()),
    MenuModel(icon: Icons.bar_chart, title:'Reports' , page: Reports()),
    
  ];
}