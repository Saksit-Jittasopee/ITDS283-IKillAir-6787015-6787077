import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({super.key});

  @override
  State<AdminUser> createState() => _AdminUserState();
}

class _AdminUserState extends State<AdminUser> {
  List<Map<String, dynamic>> _users = [
    {'id': 1, 'username': 'Suggus17', 'email': 'chanasorn.chi@student.mahidol.ac.th', 'password': 'password123', 'isAdmin': false, 'isActive': true},
    {'id': 2, 'username': 'Saksit', 'email': 'saksit.jit@student.mahidol.ac.th', 'password': 'password123', 'isAdmin': true, 'isActive': true},
    {'id': 3, 'username': 'WISHERCARTs', 'email': 'wishercarts@gmail.com', 'password': 'password123', 'isAdmin': false, 'isActive': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return _buildUserRow(_users[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRow(Map<String, dynamic> user, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(
            user['isActive'] ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: user['isActive'] ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['username'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                if (user['isAdmin'])
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(4)),
                    child: const Text('Admin', style: TextStyle(fontSize: 10, color: Colors.blue)),
                  ),
              ],
            ),
          ),
          Expanded(flex: 3, child: Text(user['email'], style: const TextStyle(fontSize: 14))),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: () => _openEditUserPage(context, user, index),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditUserPage(BuildContext context, Map<String, dynamic> user, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _UserFormPage(user: user, index: index),
      ),
    );

    if (result != null) {
      setState(() {
        _users[index] = result;
      });
    }
  }
}

class _UserFormPage extends StatefulWidget {
  final Map<String, dynamic> user;
  final int index;

  const _UserFormPage({required this.user, required this.index});

  @override
  State<_UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<_UserFormPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late bool _isAdmin;
  late bool _isActive;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user['username']);
    _passwordController = TextEditingController(text: widget.user['password']);
    _emailController = TextEditingController(text: widget.user['email']);
    _isAdmin = widget.user['isAdmin'] ?? false;
    _isActive = widget.user['isActive'] ?? true;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

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
                    const Text('Edit User', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 30),
                const Text('Username', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) => value!.isEmpty ? 'Please enter username' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Email', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  validator: (value) => value!.isEmpty ? 'Please enter email' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Password', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Please enter password' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Role: Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          Switch(
                            value: _isAdmin,
                            activeColor: Colors.blue,
                            onChanged: (val) {
                              setState(() {
                                _isAdmin = val;
                              });
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Status: Active', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          Switch(
                            value: _isActive,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              setState(() {
                                _isActive = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedUser = {
                          'id': widget.user['id'],
                          'username': _usernameController.text,
                          'email': _emailController.text,
                          'password': _passwordController.text,
                          'isAdmin': _isAdmin,
                          'isActive': _isActive,
                        };
                        Navigator.pop(context, updatedUser);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.bold)),
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