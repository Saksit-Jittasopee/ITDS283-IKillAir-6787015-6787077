import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ikillair/main.dart';
import 'package:flutter/material.dart';
import 'package:ikillair/pages/cartScreen.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';
import 'package:ikillair/pages/thankyou.dart';

class PromptpayScreen extends StatelessWidget {
  const PromptpayScreen({super.key});

  Future<void> submitOrder(BuildContext context) async {
    if (globalUserCart.isEmpty) return;

    String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
    String productNames = globalUserCart.map((e) => "${e['name']} (${e['qty']}x)").join(', ');
    double total = globalUserCart.fold(0, (sum, item) => sum + ((double.tryParse(item['price'].toString()) ?? 0.0) * (item['qty'] ?? 1)));
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    final data = {
      'orderId': orderId,
      'username': 'IKillAir User', 
      'product': productNames,
      'totalPrice': total,
      'paymentMethod': 'Promptpay'
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        globalUserCart.clear();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ThankYouScreen()));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = globalUserCart.fold(0, (sum, item) => sum + ((double.tryParse(item['price'].toString()) ?? 0.0) * (item['qty'] ?? 1)));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.arrow_back_ios, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 15),
                        const Text('Promptpay', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                          },
                          icon: const Icon(Icons.notifications_none, size: 28),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                          },
                          child: ValueListenableBuilder<dynamic>(
                          valueListenable: profileImageNotifier,
                          builder: (context, imageVal, child) {
                            ImageProvider imgProvider;
                            if (imageVal is File) {
                              imgProvider = FileImage(imageVal);
                            } else {
                              imgProvider = NetworkImage(imageVal.toString());
                            }
                            return CircleAvatar(radius: 20, backgroundImage: imgProvider);
                          },
                        ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1C3A6B),
                  ),
                  child: const Center(
                    child: Text('THAI QR PAYMENT', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 30),
                Image.network('/assets/images/payment/Promptpay.jpg', width: 250, height: 250),
                const SizedBox(height: 30),
                const Text('IKillAir Inc.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('${total.toStringAsFixed(2)} Baht', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => submitOrder(context),
                    child: const Text('Proceed to checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}