import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';
import 'package:ikillair/api/waqi_api.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<dynamic> topCities = [];

  @override
  void initState() {
    super.initState();
    _fetchTopCities();
  }

  Future<void> _fetchTopCities() async {
    final data = await WAQIapi.fetchGlobalRanking();
    if (mounted) {
      setState(() {
        if (data != null && data.length >= 2) {
          topCities = data.take(2).toList();
        }
        isLoading = false;
      });
    }
  }

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.amber;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.redAccent;
    if (aqi <= 300) return Colors.purple;
    return const Color(0xFF7A1B14);
  }

  String _getAqiStatus(int aqi) {
    if (aqi <= 50) return "Clean";
    if (aqi <= 100) return "Moderate";
    if (aqi <= 150) return "Unhealthy for SG";
    if (aqi <= 200) return "Unhealthy";
    if (aqi <= 300) return "Very Unhealthy";
    return "Hazardous";
  }

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
                      widget.onNavigate(4);
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
                      widget.onNavigate(2);
                    },
                    child: const Text('See all', style: TextStyle(color: Colors.blue, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : topCities.length >= 2
                      ? Row(
                          children: [
                            _buildPollutionCard(
                              topCities[0]['aqi'].toString(),
                              '${topCities[0]['city']}, ${topCities[0]['country']}',
                              _getAqiColor(topCities[0]['aqi']),
                              _getAqiStatus(topCities[0]['aqi']),
                            ),
                            const SizedBox(width: 15),
                            _buildPollutionCard(
                              topCities[1]['aqi'].toString(),
                              '${topCities[1]['city']}, ${topCities[1]['country']}',
                              _getAqiColor(topCities[1]['aqi']),
                              _getAqiStatus(topCities[1]['aqi']),
                            ),
                          ],
                        )
                      : const Text('No data available', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPollutionCard(String aqi, String location, Color color, String status) {
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
            Text(
              location, 
              style: const TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text('Status: $status', style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}