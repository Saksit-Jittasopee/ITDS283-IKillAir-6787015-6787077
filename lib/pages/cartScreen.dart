import 'dart:io';
import 'package:ikillair/main.dart';
import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/paymentScreen.dart';
import 'package:ikillair/pages/profileScreen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // นำ backgroundColor: Colors.white ออก
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      const Text(
                        'Cart',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
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
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? Colors.grey : Colors.black, width: 1), // ปรับสีขอบให้เข้ากับ Theme
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HealthPro 101',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '1000.00 Baht',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildQtyBtn(Icons.remove, Colors.blue),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey[800] : Colors.grey[200], // ปรับสีพื้นหลังจำนวนสินค้า
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('1', style: TextStyle(fontSize: 12)),
                              ),
                              _buildQtyBtn(Icons.add, Colors.blue),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.delete_outline, size: 28),
                  ],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PaymentScreen()),
                        );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Proceed to checkout'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}