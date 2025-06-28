// backend_url.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

const String url = 'http://pollutionviz-3hta.onrender.com';

Future<Map<String, dynamic>?> fetchDashboardData() async {
  try {
    final response = await http.get(Uri.parse('$url/get_location'));
    if (response.statusCode == 200) {
      return json.decode(response.body); // Return parsed JSON directly
    } else {
      throw Exception('Failed to load data (Status: ${response.statusCode})');
    }
  } catch (e) {
    print('API Error: $e');
    return null;
  }
}
