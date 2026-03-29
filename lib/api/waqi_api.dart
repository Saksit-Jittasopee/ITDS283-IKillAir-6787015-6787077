import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WAQIapi {
  static final String _apiKey = dotenv.env['APICN_API_KEY'] ?? '';

  static Future<Map<String, dynamic>?> fetchAqiByLocation(double lat, double lon) async {
    String url = "https://api.waqi.info/feed/geo:$lat;$lon/?token=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'ok') {
          return jsonData['data'] as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<dynamic>?> fetchGlobalRanking() async {
    final List<String> cities = [
      'lahore', 'delhi', 'kolkata', 'dhaka', 'baghdad', 
      'seoul', 'bangkok', 'shanghai', 'tokyo', 'new york', 
      'london', 'paris', 'dubai', 'jakarta', 'hanoi',
      'manama', 'chiang mai', 'beijing', 'sydney', 'los angeles'
    ];

    List<Future<Map<String, dynamic>?>> futures = cities.map<Future<Map<String, dynamic>?>>((city) async {
      String url = "https://api.waqi.info/feed/$city/?token=$_apiKey";
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData['status'] == 'ok') {
            return jsonData['data'] as Map<String, dynamic>?;
          }
        }
        return null;
      } catch (e) {
        return null;
      }
    }).toList();

    List<Map<String, dynamic>?> results = await Future.wait(futures);
    List<dynamic> validResults = [];

    for (var data in results) {
      if (data != null && data['aqi'] != null && data['aqi'] != '-') {
        validResults.add({
          'city': data['city']['name']?.split(',').first ?? 'Unknown',
          'country': _extractCountry(data['city']['name']),
          'aqi': int.tryParse(data['aqi'].toString()) ?? 0,
        });
      }
    }

    validResults.sort((a, b) => (b['aqi'] as int).compareTo(a['aqi'] as int));
    return validResults;
  }

  static String _extractCountry(String? fullName) {
    if (fullName == null) return 'Unknown';
    final parts = fullName.split(',');
    if (parts.length > 1) {
      return parts.last.trim();
    }
    return 'Unknown';
  }
}