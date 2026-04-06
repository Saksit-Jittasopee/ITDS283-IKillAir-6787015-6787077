import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> _newsList = [];
  bool _isLoading = true;
  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    fetchNews();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['JWT_SECRET'] ?? ''}', 
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        if (mounted) {
          if (data['username'] != null) {
            usernameNotifier.value = data['username'];
          }
          if (data['imagePath'] != null && data['imagePath'].toString().isNotEmpty) {
            profileImageNotifier.value = data['imagePath'];
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchNews() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/news'));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _newsList = jsonDecode(response.body);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('/uploads')) return '$baseUrl$path';
    return path;
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
                  const Text('News', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 20),
              const Text('Latest News', style: TextStyle(fontSize: 20, color: Colors.indigo)),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _newsList.isEmpty
                      ? const Center(child: Text('No news available'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _newsList.length,
                          itemBuilder: (context, index) {
                            final news = _newsList[index];
                            return _buildNewsCard(news);
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(dynamic news) {
    String displayPath = getImageUrl(news['imagePath']);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: displayPath.startsWith('assets/')
                ? Image.asset(displayPath, fit: BoxFit.cover, width: double.infinity, height: 200)
                : displayPath.startsWith('http')
                    ? Image.network(displayPath, fit: BoxFit.cover, width: double.infinity, height: 200)
                    : Image.file(File(displayPath), fit: BoxFit.cover, width: double.infinity, height: 200),
          ),
          const SizedBox(height: 15),
          Text(news['title'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(news['link'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.blue)),
          const SizedBox(height: 10),
          Text(news['source'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}