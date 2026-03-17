import 'package:flutter/material.dart';

class OurTeamScreen extends StatelessWidget {
  const OurTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      const Icon(Icons.notifications_none, size: 28),
                      const SizedBox(width: 15),
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(''),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              _buildMemberRow(
                'Chanasorn Chirapongsaton',
                '6787015',
                '',
                true,
              ),
              const SizedBox(height: 40),
              _buildMemberRow(
                'Saksit Jittasopee',
                '6787077',
                '',
                false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberRow(String name, String id, String img, bool imgLeft) {
    final info = Column(
      crossAxisAlignment: imgLeft ? CrossAxisAlignment.start : CrossAxisAlignment.start,
      children: [
        const Text('Hello I\'m', style: TextStyle(fontSize: 16)),
        Text(name, style: const TextStyle(fontSize: 16)),
        Text('Student ID: $id', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.facebook, color: Colors.blue, size: 28),
            SizedBox(width: 8),
            Icon(Icons.camera_alt, color: Colors.pink, size: 28),
            SizedBox(width: 8),
            Icon(Icons.code, color: Colors.black, size: 28),
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
      child: CircleAvatar(radius: 40, backgroundImage: NetworkImage(img)),
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