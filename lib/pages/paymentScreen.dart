import 'dart:io';
import 'package:ikillair/main.dart';
import 'package:flutter/material.dart';
import 'package:ikillair/pages/cardPayment.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';
import 'package:ikillair/pages/qrCodePayment.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // นำ backgroundColor: Colors.white ออก
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationScreen()),
                          );
                        },
                        icon: const Icon(Icons.notifications_none, size: 28),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
                        },
                        child: ValueListenableBuilder<String>(
                          valueListenable: profileImageNotifier,
                          builder: (context, imagePath, child) {
                            ImageProvider imgProvider;
                            if (imagePath.contains('assets/')) {
                              imgProvider = AssetImage(imagePath);
                            } else if (imagePath.startsWith('http')) {
                              imgProvider = NetworkImage(imagePath);
                            } else {
                              imgProvider = FileImage(File(imagePath));
                            }
                            return CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: imgProvider,
                            );
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
                  color: Theme.of(context).cardColor, // เปลี่ยนให้ปรับตาม Theme
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.grey, thickness: 1, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('HealthPro 101 (1x)', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('1000.00 Baht', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.grey, thickness: 1, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Price', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('1000.00 Baht', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    const Padding(
                      padding: EdgeInsets.only(left: 45, bottom: 10),
                    ),
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
                    const Padding(
                      padding: EdgeInsets.only(left: 45, bottom: 20),
                    ),
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