import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, String>>> fetchPVData(String type) async {
  final url = Uri.parse("http://localhost:3000/pv-data/$type");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
  
print(data["data"].runtimeType); // Check the type of the data
return List<Map<String, String>>.from(
  data["data"].map((item) {
    // Cast the item to Map<String, String> if it's not already
    final Map<String, String> convertedItem = Map<String, String>.from(item);
    return {"x": convertedItem["x"]!, "y": convertedItem["y"]!};  // Use '!' to indicate non-null
  }),
);
  } else {
    throw Exception("Failed to load PV data , status code: ${response.statusCode}");
  }
}