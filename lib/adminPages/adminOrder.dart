import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminOrder extends StatelessWidget {
  const AdminOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Orders\nManagement', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.1)),
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
                            return CircleAvatar(
                              radius: 20,
                              backgroundImage: imgProvider,
                            );
                          },
                        ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search orders',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      suffixIcon: const Icon(Icons.tune),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              color: const Color(0xFF007BFF),
              child: Row(
                children: const [
                  SizedBox(width: 40),
                  Expanded(flex: 2, child: Text("User's name", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                  Expanded(flex: 3, child: Text("Order's ID", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildOrderRow('Suggus17', '2786123227904...'),
                  _buildOrderRow('Saksit', '880087884925...'),
                  _buildOrderRow('WISHERCARTs', '970896978872...'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderRow(String name, String orderId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          const Icon(Icons.radio_button_unchecked, color: Colors.black54, size: 20),
          const SizedBox(width: 20),
          Expanded(flex: 2, child: Text(name, style: const TextStyle(fontSize: 14))),
          Expanded(flex: 3, child: Text(orderId, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}