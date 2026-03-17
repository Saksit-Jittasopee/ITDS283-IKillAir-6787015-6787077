import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('News', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Icon(Icons.notifications_none, size: 28),
                      SizedBox(width: 15),
                      CircleAvatar(radius: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Latest News', style: TextStyle(fontSize: 20, color: Colors.indigo)),
              const SizedBox(height: 20),
              _buildNewsItem(
                'https://google.com',
                'ส่องค่าฝุ่นพิษ PM2.5 สัปดาห์นี้ (6-11 มี.ค.) หลายจังหวัดยังน่าเป็นห่วง',
                '1 Hour Ago',
              ),
              const SizedBox(height: 20),
              _buildNewsItem(
                'https://google.com',
                'รัฐบาลสั่งเข้มลดการใช้พลังงาน',
                '2 Hours Ago',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsItem(String imageUrl, String title, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity, height: 200),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const Divider(height: 30),
      ],
    );
  }
}