import 'dart:convert';
import 'package:http/http.dart' as http;

class Weather {
  static const String _baseUrl = 'http://localhost:3000/weather'; // Replace with deployed backend URL if hosted

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?city=$city'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Parse JSON data
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}