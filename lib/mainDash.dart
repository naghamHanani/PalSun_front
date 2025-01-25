
import 'package:flutter/material.dart';
import 'package:test_back/const/constant.dart';
import 'package:test_back/screens/dashboard.dart';
// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashborad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor:  darkThemeBG,
        brightness: Brightness.dark,
      ),
      home: const Dashboard(),
    );
  }
}