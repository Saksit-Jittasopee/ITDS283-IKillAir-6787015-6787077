import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ikillair/main.dart';
import 'package:flutter/material.dart';
import 'package:ikillair/pages/cardPayment.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';
import 'package:ikillair/pages/qrCodePayment.dart';
import 'package:ikillair/pages/cartScreen.dart'; 

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;
  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['JWT_SECRET'] ?? ''}', 
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        if (mounted) {
          if (data['username'] != null) {
            usernameNotifier.value = data['username'];
          }
          if (data['imagePath'] != null && data['imagePath'].toString().isNotEmpty) {
            profileImageNotifier.value = data['imagePath'];
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String productNames = globalUserCart.isEmpty ? 'No items' : globalUserCart.map((e) => "${e['name']} (${e['qty']}x)").join(', ');
    double total = globalUserCart.fold(0, (sum, item) => sum + ((double.tryParse(item['price'].toString()) ?? 0.0) * (item['qty'] ?? 1)));

    return Scaffold(
      body: SafeArea(
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
                      const Text('Payment', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                            String imagePath = imageVal.toString();
                            ImageProvider imgProvider;
                            if (imagePath.contains('assets/')) {
                              imgProvider = AssetImage(imagePath);
                            } else if (imagePath.startsWith('http')) {
                              imgProvider = NetworkImage(imagePath);
                            } else {
                              imgProvider = FileImage(File(imagePath));
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, 
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.grey, thickness: 1, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            productNames, 
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ),
                        const SizedBox(width: 10),
                        Text('${total.toStringAsFixed(2)} Baht', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.grey, thickness: 1, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Price', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('${total.toStringAsFixed(2)} Baht', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.grey, thickness: 1, height: 20),
                    Row(
                      children: [
                        Radio(
                          value: 0,
                          groupValue: _selectedMethod,
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            setState(() {
                              _selectedMethod = val as int;
                            });
                          },
                        ),
                        const Text('Credit/Debit Card', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(left: 45, bottom: 10)),
                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _selectedMethod,
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            setState(() {
                              _selectedMethod = val as int;
                            });
                          },
                        ),
                        const Text('Promptpay', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(left: 45, bottom: 20)),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (_selectedMethod == 0) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CardPaymentScreen()));
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PromptpayScreen()));
                          }
                        },
                        child: const Text('Proceed to checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}