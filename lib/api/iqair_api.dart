import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IqAirApi {
  static final String _apiKey = dotenv.env['AIR_VISUAL_API_KEY']!;

  static Future<List<dynamic>?> fetchGlobalRanking() async {
    String url = "https://api.airvisual.com/v2/city_ranking?key=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          List<dynamic> dataList = jsonData['data'];
          
          dataList.sort((a, b) {
            int aqiA = a['ranking']?['current_aqi'] ?? 0;
            int aqiB = b['ranking']?['current_aqi'] ?? 0;
            return aqiB.compareTo(aqiA);
          });

          return dataList;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchWeatherByLocation(double lat, double lon) async {
    String url = "https://api.airvisual.com/v2/nearest_city?lat=$lat&lon=$lon&key=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          return jsonData['data'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}