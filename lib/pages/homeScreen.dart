import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ikillair/main.dart';
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

  List<dynamic> _newsList = [];
  bool _isNewsLoading = true;

  String baseUrl = Platform.isAndroid ? 'https://jiblee.arlifzs.site' : 'http://10.0.2.2:3001';

  @override
  void initState() {
    super.initState();
    _fetchTopCities();
    _fetchNews();
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

  Future<void> _fetchNews() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/news'));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _newsList = jsonDecode(response.body);
            _isNewsLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isNewsLoading = false);
    }
  }

String getImageUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('/Images/') || path.startsWith('Images/')) {
    String filename = path.split('/').last;
    return 'assets/images/news/$filename';
  }
  if (path.startsWith('/uploads')) return '$baseUrl$path';
  return path;
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
                            String imagePath = imageVal.toString();
                            ImageProvider imgProvider;
                            if (imagePath.contains('assets/')) {
                              imgProvider = AssetImage(imagePath);
                            } else if (imagePath.startsWith('http')) {
                              imgProvider = NetworkImage(imagePath);
                            } else {
                              imgProvider = FileImage(File(imagePath));
                            }
                            return CircleAvatar(radius: 20, backgroundImage: imgProvider);
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
                  const Text('News', style: TextStyle(fontSize: 20, color: Colors.indigo, fontWeight: FontWeight.w500)),
                  GestureDetector(
                    onTap: () => widget.onNavigate(4),
                    child: const Text('See all', style: TextStyle(color: Colors.blue, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _isNewsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _newsList.isEmpty
                      ? const Text('No news available', style: TextStyle(color: Colors.grey))
                      : _buildLatestNewsCard(_newsList[0]),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Live most polluted global major city ranking',
                      style: TextStyle(fontSize: 18, color: Colors.indigo),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onNavigate(2),
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

  Widget _buildLatestNewsCard(dynamic news) {
    String displayPath = getImageUrl(news['image']); // ✅ image ไม่ใช่ imagePath

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (displayPath.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: displayPath.startsWith('assets/')
    ? Image.asset(displayPath, fit: BoxFit.cover, width: double.infinity, height: 200,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image))
    : displayPath.startsWith('http')
        ? Image.network(displayPath, fit: BoxFit.cover, width: double.infinity, height: 200)
        : const SizedBox(),
          ),
        const SizedBox(height: 15),
        Text(news['name'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // ✅ name
        const SizedBox(height: 10),
        Text(news['source'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),        // ✅ source
      ],
    );
  }

  Widget _buildPollutionCard(String aqi, String location, Color color, String status) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            const Text('AQI', style: TextStyle(color: Colors.white, fontSize: 12)),
            Text(aqi, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            Text(location, style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text('Status: $status', style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
