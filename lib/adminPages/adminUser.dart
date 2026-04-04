import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ikillair/adminPages/adminNotification.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({super.key});

  @override
  State<AdminUser> createState() => _AdminUserState();
}

class _AdminUserState extends State<AdminUser> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _users = [];
  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    fetchUsers('');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/search/admin/users?q=$query'));
      if (response.statusCode == 200) {
        setState(() {
          _users = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminNotification()));
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
                    onChanged: (value) => fetchUsers(value),
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
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(10),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 900,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          color: const Color(0xFF007BFF),
                          child: Row(
                            children: const [
                              SizedBox(width: 60, child: Text("Status", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 150, child: Text("Username", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 100, child: Text("Role", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 250, child: Text("Email", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 120, child: Text("Password", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 100, child: Text("Actions", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _users.length,
                            itemBuilder: (context, index) {
                              return _buildUserRow(_users[index] as Map<String, dynamic>, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddUserPage(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildUserRow(Map<String, dynamic> user, int index) {
    bool isActive = user['isActive'] ?? true;
    bool isAdmin = user['isAdmin'] ?? false;
    String username = user['username'] ?? 'Unknown';
    String email = user['email'] ?? 'Unknown';
    String password = user['password'] ?? '******';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                isActive ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isActive ? Colors.green : Colors.grey,
                size: 20,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(username, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: isAdmin ? Colors.blue.shade100 : Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  isAdmin ? 'Admin' : 'User',
                  style: TextStyle(fontSize: 12, color: isAdmin ? Colors.blue : Colors.grey.shade700, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 250,
            child: Text(email, style: const TextStyle(fontSize: 14)),
          ),
          SizedBox(
            width: 120,
            child: Text(password, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: () => _openEditUserPage(context, user, index),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _confirmDeleteUser(context, username, index),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, String username, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User?'),
        content: Text('Are you sure you want to delete user "$username"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _users.removeAt(index);
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddUserPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const _UserFormPage(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final newId = _users.isEmpty ? 1 : _users.map((u) => (u['id'] as int?) ?? 0).reduce((a, b) => a > b ? a : b) + 1;
        result['id'] = newId;
        _users.add(result);
      });
    }
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
  final Map<String, dynamic>? user;
  final int? index;

  const _UserFormPage({this.user, this.index});

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
    bool isEdit = widget.user != null;
    _usernameController = TextEditingController(text: isEdit ? widget.user!['username']?.toString() ?? '' : '');
    _passwordController = TextEditingController(text: isEdit ? widget.user!['password']?.toString() ?? '' : '');
    _emailController = TextEditingController(text: isEdit ? widget.user!['email']?.toString() ?? '' : '');
    _isAdmin = isEdit ? (widget.user!['isAdmin'] ?? false) : false;
    _isActive = isEdit ? (widget.user!['isActive'] ?? true) : true;
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
    bool isEdit = widget.user != null;

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
                    Text(isEdit ? 'Edit User' : 'Add User', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                          'id': isEdit ? widget.user!['id'] : null,
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
                    child: Text(isEdit ? 'SAVE CHANGES' : 'ADD USER', style: const TextStyle(fontWeight: FontWeight.bold)),
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