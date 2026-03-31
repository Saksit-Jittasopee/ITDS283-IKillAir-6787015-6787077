import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // นำ backgroundColor: Colors.white ออก เพื่อให้ใช้สีตาม Theme
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 15),
                  const Text('Notification', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildSectionHeader('TODAY'),
                  _buildNotiItem(context, Icons.card_membership, 'A products payout of \$19 has been successful!', '11.00 AM', Colors.pink[50]!),
                  _buildNotiItem(context, Icons.add_circle_outline, 'Bangkok, Thailand AQI at 90 today.', '08.00 AM', Colors.pink[50]!),
                  _buildNotiItem(context, Icons.shopping_bag_outlined, 'New Product "HealthPro 404" Released Today!', '11.00 AM', Colors.pink[50]!),
                  _buildNotiItem(context, Icons.public, 'Bangkok, Thailand AQI at 92 today.', '08.00 AM', Colors.pink[50]!),
                  _buildNotiItem(context, Icons.newspaper, 'Today PM2.5 News! Readmore at https:...', '01.00 AM', Colors.yellow[50]!),
                  const SizedBox(height: 20),
                  _buildSectionHeader('YESTERDAY'),
                  _buildNotiItem(context, Icons.shopping_bag_outlined, 'New Product "HealthPro 101" Released Today!', '11.00 AM', Colors.pink[50]!),
                  _buildNotiItem(context, Icons.public, 'Bangkok, Thailand AQI at 102 today.', '08.00 AM', Colors.pink[50]!),
                  _buildNotiItem(context, Icons.newspaper, 'PM2.5 Reach Highest Today! Readmore at https:...', '01.00 AM', Colors.yellow[50]!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.2)),
    );
  }

  Widget _buildNotiItem(BuildContext context, IconData icon, String message, String time, Color lightBgColor) {
    // ปรับสีพื้นหลังไอคอนให้เข้ากับ Dark Mode
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? Colors.grey[800]! : lightBgColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: isDark ? Colors.white70 : Colors.brown[300]),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: const TextStyle(fontSize: 13, height: 1.4)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}