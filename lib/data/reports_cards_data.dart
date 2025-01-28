import 'package:flutter/material.dart';
import 'package:test_back/models/health_model.dart';

class ReportsCardsData {
  List<HealthModel> get dailyCardsData => [
        HealthModel(icon: Icons.sunny, value: '100', title: "Today's Pv Generation"),
        HealthModel(icon: Icons.battery_5_bar_outlined, value: '500', title: "Charging"),
        HealthModel(icon: Icons.battery_1_bar_outlined, value: '1', title: "Discharging"),
        HealthModel(icon: Icons.error, value: '2', title: "Faulty plants"),
        HealthModel(icon: Icons.bolt, value: '20', title: "Working plants"),
        HealthModel(icon: Icons.power, value: '20', title: "Consumption"),
      ];

  List<HealthModel> get weeklyCardsData => [
        HealthModel(icon: Icons.sunny, value: '700', title: "This week's Pv Generation"),
        HealthModel(icon: Icons.battery_5_bar_outlined, value: '500', title: "Charging"),
        HealthModel(icon: Icons.battery_1_bar_outlined, value: '1', title: "Discharging"),
        HealthModel(icon: Icons.error, value: '2', title: "Faulty plants"),
        HealthModel(icon: Icons.bolt, value: '20', title: "Working plants"),
        HealthModel(icon: Icons.power, value: '20', title: "Consumption"),
      ];

  List<HealthModel> get monthlyCardsData => [
        HealthModel(icon: Icons.sunny, value: '3000', title: "This month's Pv Generation"),
        HealthModel(icon: Icons.battery_5_bar_outlined, value: '500', title: "Charging"),
        HealthModel(icon: Icons.battery_1_bar_outlined, value: '1', title: "Discharging"),
        HealthModel(icon: Icons.error, value: '2', title: "Faulty plants"),
        HealthModel(icon: Icons.bolt, value: '20', title: "Working plants"),
        HealthModel(icon: Icons.power, value: '20', title: "Consumption"),
      ];

  List<HealthModel> get yearlyCardsData => [
        HealthModel(icon: Icons.sunny, value: '36000', title: "This year's Pv Generation"),
        HealthModel(icon: Icons.battery_5_bar_outlined, value: '500', title: "Charging"),
        HealthModel(icon: Icons.battery_1_bar_outlined, value: '1', title: "Discharging"),
        HealthModel(icon: Icons.error, value: '2', title: "Faulty plants"),
        HealthModel(icon: Icons.bolt, value: '20', title: "Working plants"),
        HealthModel(icon: Icons.power, value: '20', title: "Consumption"),
      ];
}
