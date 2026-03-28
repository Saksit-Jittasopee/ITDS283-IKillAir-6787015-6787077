import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IqAirApi { //use for global city ranking
  static final String _apiKey = dotenv.env['AIR_VISUAL_API_KEY']!;

  static Future<List<dynamic>?> fetchGlobalRanking() async {
    String url = "http://api.airvisual.com/v2/city_ranking?key=$_apiKey";

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