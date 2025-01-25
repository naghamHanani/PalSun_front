import 'package:flutter/material.dart';
import 'package:test_back/models/health_model.dart';
import 'weather.dart';

class HealthDetails {

  String weatherDescription = 'Loading weather...';
  String city = 'Nablus';
  final Weather weather = Weather();
  late IconData thisIcon=Icons.wb_cloudy;

  static final HealthDetails _instance = HealthDetails._internal(); 

  HealthDetails._internal() {
    _fetchWeather(); // Fetch weather on initialization
  }
  
   factory HealthDetails() => _instance;

  
  void _fetchWeather() async {
    try {
      final weatherData = await weather.fetchWeather(city);

      weatherDescription =
          "Temp: ${weatherData['current']['temp_c']}°C, ${weatherData['current']['condition']['text']}";
      thisIcon = _getWeatherIcon(weatherData['current']['condition']['text']);
    } catch (e) {
      weatherDescription = 'Failed to load weather';
      thisIcon = Icons.error; // Default icon for error
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
      return Icons.wb_cloudy; // Default
    }
  }

  
  List<HealthModel> get healthData => [
        HealthModel(
          icon: thisIcon,
          value: weatherDescription, 
          title: "Today's weather", 
        ),
        
        HealthModel(
          icon: Icons.wb_sunny,
          value: '4000', 
          title: "Today's total Pv Generation", 
        ),
        
        HealthModel(
          icon: Icons.bolt,
          value: '20', 
          title: "Working plants", 
        ),
        HealthModel(
          icon: Icons.error,
          value: '1', 
          title: "Faulty plants", 
        ),


      ];
}
