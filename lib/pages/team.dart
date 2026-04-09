import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ikillair/main.dart';
import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';

class OurTeamScreen extends StatefulWidget {
  const OurTeamScreen({super.key});

  @override
  State<OurTeamScreen> createState() => _OurTeamScreenState();
}

class _OurTeamScreenState extends State<OurTeamScreen> {
  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    // _fetchUserProfile();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // Future<void> _fetchUserProfile() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/api/users/profile'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer ${dotenv.env['JWT_SECRET'] ?? ''}', 
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body)['data'];
  //       if (mounted) {
  //         if (data['username'] != null) {
  //           usernameNotifier.value = data['username'];
  //         }
  //         if (data['imagePath'] != null && data['imagePath'].toString().isNotEmpty) {
  //           profileImageNotifier.value = data['imagePath'];
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_back_ios, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 15),
                      const Text('Our Team', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
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
                          Navigator.pop(context);
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
              const SizedBox(height: 50),
              _buildMemberRow(
                context,
                'Chanasorn Chirapongsaton',
                '6787015',
                'assets/images/team/Chanasorn.jpg',
                true,
                'https://www.facebook.com/chanasorn.sugus',
                'https://www.instagram.com/nebu1.su_/',
                'https://github.com/SugguSCH',
              ),
              const SizedBox(height: 40),
              _buildMemberRow(
                context,
                'Saksit Jittasopee',
                '6787077',
                'assets/images/team/Saksit.jpg',
                false,
                'https://www.facebook.com/saksit.jittasopee.1/',
                'https://www.instagram.com/saksitjittasopee/',
                'https://github.com/Saksit-Jittasopee',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberRow(
    BuildContext context, 
    String name, 
    String id, 
    String imgPath, 
    bool imgLeft,
    String fbUrl,
    String igUrl,
    String codeUrl,
  ) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hello I\'m', style: TextStyle(fontSize: 16)),
        Text(name, style: const TextStyle(fontSize: 16)),
        Text('Student ID: $id', style: const TextStyle(fontSize: 16, color: Colors.grey)), 
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _launchUrl(fbUrl),
              child: const Icon(Icons.facebook, color: Colors.blue, size: 28),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () => _launchUrl(igUrl),
              child: const Icon(Icons.camera_alt, color: Colors.pink, size: 28),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () => _launchUrl(codeUrl),
              child: Icon(Icons.code, color: isDark ? Colors.white : Colors.black, size: 28),
            ),
          ],
        ),
      ],
    );

    final profileImg = Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [Colors.cyan, Colors.blue]),
      ),
      padding: const EdgeInsets.all(3),
      child: CircleAvatar(radius: 40, backgroundImage: AssetImage(imgPath)),
    );

    return Row(
      mainAxisAlignment: imgLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (imgLeft) ...[profileImg, const SizedBox(width: 20), info]
        else ...[info, const SizedBox(width: 20), profileImg],
      ],
    );
  }
}