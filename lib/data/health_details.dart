import 'package:flutter/material.dart';
import 'package:test_back/models/health_model.dart';
import 'weather.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class HealthDetails {

  late IO.Socket socket;  // Socket connection
  //double pvGenerationValue =0;  // Variable to hold the Pv Generation data

  // StreamController to notify listeners about changes to pvGenerationValue
  final _pvGenerationController = StreamController<double>.broadcast();
  
  double pvGenerationValue =0 ;

  // Connect to the Socket.io server
  void _connectSocket() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.connect();
    socket.on('pvUpdate', (data) {
       print("Received pv generation data: $data");  // This will print the whole received data

  // Check if data is a Map before accessing its contents
  if (data is Map<String, dynamic>) {
    // Now you can access the key properly
     var pvGeneration = data['totalPvGeneration'];
    print("Received Pv Generation: $pvGeneration");

    // If the pvGeneration is not a double, convert it
    if (pvGeneration is double) {

       _setPvGeneration(pvGeneration); 
        print("Pv Generation as double: $pvGeneration");

    } else if (pvGeneration is int) {

      pvGeneration = pvGeneration.toDouble();
      _setPvGeneration(pvGeneration);
      print("Emitting updated pvGeneration: $pvGeneration");

      //pvGenerationValue=pvGeneration;
      print("Pv Generation as double: $pvGeneration");
    } else {
      print("Unexpected data type for 'totalPvGeneration': ${pvGeneration.runtimeType}");
    }
  } else {
    print("Unexpected data format for 'pvUpdate': ${data.runtimeType}");
  }
    });
  }

  // Private method to update pvGenerationValue
  void _setPvGeneration(double value) {
    pvGenerationValue = value;
      _pvGenerationController.add(pvGenerationValue); 
      print("Emitting updated pvGeneration: $pvGenerationValue");
  }

  Stream<double> get pvGenerationStream => _pvGenerationController.stream;


  String weatherDescription = 'Loading weather...';
  String city = 'Nablus';
  final Weather weather = Weather();
  late IconData thisIcon=Icons.wb_cloudy;

  static final HealthDetails _instance = HealthDetails._internal(); 

  HealthDetails._internal() {
    _fetchWeather(); // Fetch weather on initialization
    
     _connectSocket();  // Connect to the socket when this class is initialized
  
  }
  
   factory HealthDetails( ) => _instance;


  
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
          icon: Icons.flash_on,
          value: pvGenerationValue.toString(),
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
