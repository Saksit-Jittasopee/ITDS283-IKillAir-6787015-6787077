import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SearchProductService {
  static Future<List<dynamic>> searchProducts(String keyword) async {
    String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
    String url = "$baseUrl/api/search?q=$keyword";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body); 
      }
      return [];
    } catch (e) {
      print("Connection failed: $e");
      return [];
    }
  }
}