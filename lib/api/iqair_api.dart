import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IqAirApi {
  static final String _apiKey = dotenv.env['AIR_VISUAL_API_KEY']!;

  static Future<Map<String, dynamic>?> fetchBangkokAqi() async {
    const List<String> city = ['bangkok', 'shanghai', 'tokyo', 'losangeles', 'newyork'];
    const List<String> state = ['bangkok', 'shanghai', 'tokyo', 'california', 'newyork'];
    const List<String> country = ['us', 'uk', 'thailand', 'japan', 'china'];
    
    String url = "http://api.airvisual.com/v2/city?city=$city&state=$state&country=$country&key=$_apiKey";

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