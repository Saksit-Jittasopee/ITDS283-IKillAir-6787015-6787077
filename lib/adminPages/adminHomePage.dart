import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ikillair/adminPages/adminNotification.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminHome extends StatelessWidget {
  final Function(int)? onNavigate;

  const AdminHome({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: usernameNotifier,
                    builder: (context, username, child) {
                      return Text(
                        'Hello, $username 👋',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminNotification()));
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
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Products Management', style: TextStyle(fontSize: 20, color: Colors.indigo, fontWeight: FontWeight.w500)),
                  GestureDetector(
                    onTap: () {
                      if (onNavigate != null) onNavigate!(1);
                    },
                    child: const Text('See all', style: TextStyle(color: Colors.blue, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildStatCard(
                context,
                'Products Available',
                '71 Products',
                Icons.inventory_2,
                Colors.orange.shade100,
                Colors.orange,
              ),
              const SizedBox(height: 15),
              _buildStatCard(
                context,
                'Total Product Sales',
                '89,000 Baht',
                Icons.show_chart,
                Colors.green.shade100,
                Colors.green,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Users Management', style: TextStyle(fontSize: 20, color: Colors.indigo, fontWeight: FontWeight.w500)),
                  GestureDetector(
                    onTap: () {
                      if (onNavigate != null) onNavigate!(2); // เปลี่ยนไปแท็บ Users (index 2)
                    },
                    child: const Text('See all', style: TextStyle(color: Colors.blue, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Users', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey, fontSize: 14)),
                            const SizedBox(height: 8),
                            const Text('3', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.indigo.shade50, shape: BoxShape.circle),
                          child: Icon(Icons.people, color: Colors.indigo.shade300, size: 30),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.trending_up, color: Colors.teal, size: 16),
                        const SizedBox(width: 8),
                        Text('2 Users currently online', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey, fontSize: 12)),
                      ],
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

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color bgColor, Color iconColor) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey, fontSize: 14)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 30),
          ),
        ],
      ),
    );
  }
}