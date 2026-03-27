import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IqAirApi {
  static final String _apiKey = dotenv.env['APICN_API_KEY']!;

  static Future<Map<String, dynamic>?> fetchDataAqi() async {
    final List<String> _cities = ['bangkok', 'shanghai', 'tokyo', 'london', 'newyork'];
    String _selectedCity = 'shanghai';
    
    await Future.delayed(Duration(seconds: 1)); // Simulated delay

    String url = "http://api.waqi.info/feed/$_selectedCity/?token=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}