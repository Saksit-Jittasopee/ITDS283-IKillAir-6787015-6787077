import 'dart:io';
import 'package:ikillair/main.dart';
import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';

class OurTeamScreen extends StatelessWidget {
  const OurTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // นำ backgroundColor: Colors.white ออก
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
                          Navigator.pop(context);
                        },
                        child: ValueListenableBuilder<String>(
                          valueListenable: profileImageNotifier,
                          builder: (context, imagePath, child) {
                            ImageProvider imgProvider;
                            if (imagePath.contains('assets/')) {
                              imgProvider = AssetImage(imagePath);
                            } else if (imagePath.startsWith('http')) {
                              imgProvider = NetworkImage(imagePath);
                            } else {
                              imgProvider = FileImage(File(imagePath));
                            }
                            return CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: imgProvider,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              _buildMemberRow(
                context, // ส่ง context ไปด้วยเพื่อเช็ค Theme
                'Chanasorn Chirapongsaton',
                '6787015',
                'assets/images/team/Chanasorn.jpg',
                true,
              ),
              const SizedBox(height: 40),
              _buildMemberRow(
                context,
                'Saksit Jittasopee',
                '6787077',
                'assets/images/team/Saksit.jpg',
                false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberRow(BuildContext context, String name, String id, String imgPath, bool imgLeft) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hello I\'m', style: TextStyle(fontSize: 16)),
        Text(name, style: const TextStyle(fontSize: 16)),
        Text('Student ID: $id', style: TextStyle(fontSize: 16, color: Colors.grey)), // เปลี่ยนเป็นสีที่เหมาะกับทั้งสอง Theme
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.facebook, color: Colors.blue, size: 28),
            const SizedBox(width: 8),
            const Icon(Icons.camera_alt, color: Colors.pink, size: 28),
            const SizedBox(width: 8),
            Icon(Icons.code, color: isDark ? Colors.white : Colors.black, size: 28), // เปลี่ยนสีไอคอน Code ให้เข้ากับ Theme
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