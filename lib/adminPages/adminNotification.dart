import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminNotification extends StatefulWidget {
  const AdminNotification({super.key});

  @override
  State<AdminNotification> createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'A products payout of \$19 has been successful!',
      'target': 'everyone',
      'time': '11.00 AM'
    },
    {
      'id': 2,
      'title': 'Admin dashboard update completed.',
      'target': 'only admin',
      'time': '09.30 AM'
    },
    {
      'id': 3,
      'title': 'Welcome new users to IKillAir!',
      'target': 'only user',
      'time': '08.00 AM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

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
                                ImageProvider imgProvider;
                                if (imageVal is File) {
                                  imgProvider = FileImage(imageVal);
                                } else {
                                  imgProvider = NetworkImage(imageVal.toString());
                                }
                                return CircleAvatar(
                                  radius: 20,
                                  backgroundImage: imgProvider,
                                );
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
                  return _buildNotificationCard(_notifications[index], index, isDark);
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

  Widget _buildNotificationCard(Map<String, dynamic> noti, int index, bool isDark) {
    IconData targetIcon;
    Color targetColor;

    if (noti['target'] == 'only admin') {
      targetIcon = Icons.admin_panel_settings;
      targetColor = Colors.purple;
    } else if (noti['target'] == 'only user') {
      targetIcon = Icons.person;
      targetColor = Colors.orange;
    } else {
      targetIcon = Icons.public;
      targetColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: targetColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(targetIcon, color: targetColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(noti['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.3)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('To: ${noti['target']}', style: TextStyle(fontSize: 12, color: targetColor, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 10),
                    Text(noti['time'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
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
                onPressed: () => _confirmDeleteNotification(context, index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteNotification(BuildContext context, int index) {
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
              setState(() {
                _notifications.removeAt(index);
              });
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

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final newId = _notifications.isEmpty ? 1 : _notifications.map((n) => n['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
        result['id'] = newId;
        _notifications.insert(0, result);
      });
    }
  }

  Future<void> _openEditNotificationPage(BuildContext context, Map<String, dynamic> noti, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _NotificationFormPage(notification: noti, index: index),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _notifications[index] = result;
      });
    }
  }
}

class _NotificationFormPage extends StatefulWidget {
  final Map<String, dynamic>? notification;
  final int? index;

  const _NotificationFormPage({this.notification, this.index});

  @override
  State<_NotificationFormPage> createState() => _NotificationFormPageState();
}

class _NotificationFormPageState extends State<_NotificationFormPage> {
  late TextEditingController _titleController;
  String _selectedTarget = 'everyone';
  final _formKey = GlobalKey<FormState>();

  final List<String> _targetOptions = ['everyone', 'only admin', 'only user'];

  @override
  void initState() {
    super.initState();
    bool isEdit = widget.notification != null;
    _titleController = TextEditingController(text: isEdit ? widget.notification!['title'] : '');
    if (isEdit && _targetOptions.contains(widget.notification!['target'])) {
      _selectedTarget = widget.notification!['target'];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
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
                const Text('Title', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Please enter notification title' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Sending to', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedTarget,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                  items: _targetOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTarget = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final now = DateTime.now();
                        String timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
                        
                        final updatedNoti = {
                          'id': isEdit ? widget.notification!['id'] : null,
                          'title': _titleController.text,
                          'target': _selectedTarget,
                          'time': isEdit ? widget.notification!['time'] : timeString,
                        };
                        Navigator.pop(context, updatedNoti);
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