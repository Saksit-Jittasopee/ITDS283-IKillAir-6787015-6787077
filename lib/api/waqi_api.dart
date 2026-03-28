import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WAQIapi { //use for pollution info (CO2, NO2, NH3, SO2, AQI)
  static final String _apiKey = dotenv.env['APICN_API_KEY'] ?? 'YOUR_API_KEY';

  static Future<Map<String, dynamic>?> fetchAqiByLocation(double lat, double lon) async {
    String url = "https://api.waqi.info/feed/geo:$lat;$lon/?token=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'ok') {
          return jsonData['data'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}