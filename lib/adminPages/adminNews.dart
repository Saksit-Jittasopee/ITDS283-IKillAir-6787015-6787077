import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminNews extends StatelessWidget {
  const AdminNews({super.key});

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
                children: [
                  const Text('News Management', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage('/assets/images/team/Chanasorn.jpg'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network('/assets/images/news/pm2.5.webp', fit: BoxFit.cover),
              ),
              const SizedBox(height: 15),
              const Text(
                'ส่องค่าฝุ่นพิษ PM2.5 สัปดาห์นี้ (6-11 มี.ค.) หลายจังหวัดยังน่าเป็นห่วง',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'https://www.bbc.com/thai/articles/ckkl7r05z34o',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                '1 Hour Ago - BBC Thailand',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network('/assets/images/news/reduce_energy.jpg', fit: BoxFit.cover),
              ),
              const SizedBox(height: 15),
              const Text(
                'รัฐบาลออกมาตรการประหยัดพลังงาน พลัส ยกกำลัง 2 ควบคุมราคาสินค้า สั่งผู้ว่าฯ ผ่อนผัน รถส่งน้ำมันวิ่ง 24 ชม.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'https://www.prd.go.th/th/content/category/detail/id/39/iid/486544',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                '4 Hour Ago - กรมประชาสัมพันธ์ PRD',
                style: TextStyle(fontSize: 14),
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