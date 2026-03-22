import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminUser extends StatelessWidget {
  const AdminUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Users\nManagement', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.1)),
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
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      suffixIcon: const Icon(Icons.tune),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              color: const Color(0xFF007BFF),
              child: Row(
                children: const [
                  SizedBox(width: 40),
                  Expanded(flex: 2, child: Text("User's name", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                  Expanded(flex: 3, child: Text("Email", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildUserRow('Suggus17', 'chanasorn.chi...'),
                  _buildUserRow('Saksit', 'saksit.jit@stu...'),
                  _buildUserRow('WISHERCARTs', 'wishercarts@...'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRow(String name, String email) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          const Icon(Icons.radio_button_unchecked, color: Colors.black54, size: 20),
          const SizedBox(width: 20),
          Expanded(flex: 2, child: Text(name, style: const TextStyle(fontSize: 14))),
          Expanded(flex: 3, child: Text(email, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}