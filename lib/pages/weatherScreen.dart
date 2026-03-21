import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Weather', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: Colors.blue, size: 16),
                          Text(' Bangkok, Thailand', style: TextStyle(color: Colors.grey)),
                        ],
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
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network('/assets/images/weather/Bangkok.webp', fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Today', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text('22 Feb, Sunday', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 10),
                      _weatherDetail(Icons.nightlight_round, 'Clean'),
                      _weatherDetail(Icons.air, '10.8 km/h'),
                      _weatherDetail(Icons.water_drop_outlined, '34%'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text('20:00', style: TextStyle(fontSize: 40)),
                      Text('28°', style: TextStyle(fontSize: 40)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _hourlyCard('Now', Icons.nightlight_round, '28°', true),
                  _hourlyCard('00:00', Icons.umbrella_outlined, '25°', false),
                  _hourlyCard('05:00', Icons.cloud_outlined, '27°', false),
                  _hourlyCard('10:00', Icons.wb_sunny_outlined, '33°', false),
                  _hourlyCard('15:00', Icons.wb_sunny_outlined, '34°', false),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _weatherDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          Text(' $text', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _hourlyCard(String time, IconData icon, String temp, bool isNow) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: isNow ? Colors.blue : Colors.blue[400],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 10)),
          const SizedBox(height: 8),
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(temp, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}