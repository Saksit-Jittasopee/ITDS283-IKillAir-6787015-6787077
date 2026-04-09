import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminNotification extends StatefulWidget {
  const AdminNotification({super.key});

  @override
  State<AdminNotification> createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  List<dynamic> _notifications = [];
  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/notifications'));
      if (response.statusCode == 200) {
        setState(() {
          _notifications = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/notifications/admin/$id'),
        headers: {'Authorization': 'Bearer ${tokenNotifier.value}'}, 
      );
      if (response.statusCode == 200) fetchNotifications();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
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
                      const Text('Notifications\nManagement', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.1)),
                    ],
                  ),
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
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationCard(_notifications[index], index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddNotificationPage(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNotificationCard(dynamic noti, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.notifications, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(noti['name'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.3)),
                const SizedBox(height: 8),
                Text(noti['message'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                onPressed: () => _openEditNotificationPage(context, noti, index),
              ),
              const SizedBox(height: 15),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                onPressed: () => _confirmDeleteNotification(context, noti['id']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteNotification(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification?'),
        content: const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteNotification(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddNotificationPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const _NotificationFormPage()),
    );

    if (result != null) {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/notifications/admin'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${tokenNotifier.value}', 
          },
          body: jsonEncode(result),
        );
        if (response.statusCode == 201) fetchNotifications();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _openEditNotificationPage(BuildContext context, dynamic noti, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _NotificationFormPage(notification: noti)),
    );

    if (result != null) {
      try {
        final response = await http.put(
          Uri.parse('$baseUrl/api/notifications/admin/${noti['id']}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${tokenNotifier.value}', 
          },
          body: jsonEncode(result),
        );
        if (response.statusCode == 200) fetchNotifications();
      } catch (e) {
        print(e);
      }
    }
  }
}

class _NotificationFormPage extends StatefulWidget {
  final dynamic notification;

  const _NotificationFormPage({this.notification});

  @override
  State<_NotificationFormPage> createState() => _NotificationFormPageState();
}

class _NotificationFormPageState extends State<_NotificationFormPage> {
  late TextEditingController _nameController;
  late TextEditingController _messageController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bool isEdit = widget.notification != null;
    _nameController = TextEditingController(text: isEdit ? widget.notification['name'] : '');       
    _messageController = TextEditingController(text: isEdit ? widget.notification['message'] : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.notification != null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(isEdit ? 'Edit Notification' : 'New Notification', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 40),
                const Text('Name', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  validator: (value) => value!.isEmpty ? 'Please enter notification name' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Message', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _messageController,
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Please enter message' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final data = {
                          'name': _nameController.text,       
                          'message': _messageController.text, 
                          'userId': userIdNotifier.value, 
                        };
                        Navigator.pop(context, data);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(isEdit ? 'SAVE CHANGES' : 'SEND NOTIFICATION', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
