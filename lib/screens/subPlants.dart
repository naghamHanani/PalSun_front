import 'package:flutter/material.dart';

class SubPlants extends StatefulWidget {
  const SubPlants({super.key});

  @override
  State<SubPlants> createState() => _SubPlantsState();
}

class _SubPlantsState extends State<SubPlants> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Sub Plants page !')),
      ),
      
    );
  }
}