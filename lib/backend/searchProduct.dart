import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SearchProductService {
  static Future<List<dynamic>> searchProducts(String keyword) async {
    // เช็คว่ารันบน Android Emulator หรือไม่ ถ้าใช่ให้ใช้ 10.0.2.2
    String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
    String url = "$baseUrl/api/search?q=$keyword";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // คืนค่าข้อมูลที่ได้จาก Node.js
      }
      return [];
    } catch (e) {
      print("เชื่อมต่อ Server ไม่สำเร็จ: $e");
      return [];
    }
  }
}