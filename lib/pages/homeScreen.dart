import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

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
                  Row(
                    children: const [
                      Text(
                        'Hello, Saksit 👋',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage('/assets/images/team/Saksit.jpg'),
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
                  const Text('News', style: TextStyle(fontSize: 20, color: Colors.indigo, fontWeight: FontWeight.w500)),
                  GestureDetector(
                    onTap: () {
                      onNavigate(4);
                    },
                    child: const Text('See all', style: TextStyle(color: Colors.blue, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
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
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              const Text(
                '1 Hour Ago - BBC Thailand',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Live most polluted global major city ranking',
                    style: TextStyle(fontSize: 18, color: Colors.indigo),
                  ),
                  GestureDetector(
                    onTap: () {
                      onNavigate(2);
                    },
                    child: const Text('See all', style: TextStyle(color: Colors.blue, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  _buildPollutionCard('179', 'Lahore, Pakistan', Colors.redAccent),
                  const SizedBox(width: 15),
                  _buildPollutionCard('178', 'Kolkata, India', Colors.redAccent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPollutionCard(String aqi, String city, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text('AQI', style: TextStyle(color: Colors.white, fontSize: 12)),
            Text(aqi, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            Text(city, style: const TextStyle(color: Colors.white, fontSize: 10)),
            const Text('Status: Poor', style: TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}