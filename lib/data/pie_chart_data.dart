import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartData{
  final paiChartSelectionDatas = [
    PieChartSectionData(
      color:   Colors.blue,
      value: 25,
      showTitle: false,
      radius: 25,
    ),
    PieChartSectionData(
      color: const Color(0xFF26E5FF),
      value: 20,
      showTitle: false,
      radius: 22,
    ),
    PieChartSectionData(
      color: const Color(0xFFFFCF26),
      value: 10,
      showTitle: false,
      radius: 19,
    ),
    PieChartSectionData(
      color: const Color(0xFFEE2727),
      value: 15,
      showTitle: false,
      radius: 16,
    ),
    PieChartSectionData(
      color: const Color.fromARGB(255, 3, 32, 84).withOpacity(0.1),
      value: 25,
      showTitle: false,
      radius: 13,
    ),
  ];
}