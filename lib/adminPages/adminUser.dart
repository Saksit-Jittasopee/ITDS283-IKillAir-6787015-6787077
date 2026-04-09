import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    fetchUsers('');
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokenNotifier.value}',
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

  Future<void> fetchUsers(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/admin?q=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokenNotifier.value}'
        },
      );
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        setState(() {
          if (decodedData is List) {
            _users = decodedData;
          } else if (decodedData is Map && decodedData.containsKey('data')) {
            _users = decodedData['data'];
          } else if (decodedData is Map && decodedData.containsKey('users')) {
            _users = decodedData['users'];
          } else {
            _users = [];
          }
        });
      } else {
        print('Error Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch Error: $e');
    }
  }

  Future<void> createUser(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/admin'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokenNotifier.value}',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        fetchUsers(_currentQuery);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/users/admin/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokenNotifier.value}',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        fetchUsers(_currentQuery);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/users/admin/$id'),
        headers: {'Authorization': 'Bearer ${tokenNotifier.value}'},
      );
      if (response.statusCode == 200) {
        fetchUsers(_currentQuery);
      }
    } catch (e) {
      print(e);
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
                                String imagePath = imageVal.toString();
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
                    onChanged: (value) {
                      _currentQuery = value;
                      fetchUsers(_currentQuery);
                    },
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
                              return _buildUserRow(_users[index], index);
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

  Widget _buildUserRow(dynamic user, int index) {
    bool isActive = user['status'] ?? user['Status'] ?? user['User_Status'] ?? true;
    bool isAdmin = user['role'] ?? user['Role'] ?? user['User_Role'] ?? false;
    String username = user['username'] ?? user['Username'] ?? user['User_Name'] ?? 'Unknown';
    String email = user['email'] ?? user['Email'] ?? user['User_Email'] ?? 'Unknown';
    String password = '******';

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
                    onPressed: () => _confirmDeleteUser(context, user),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, dynamic user) {
    String username = user['username'] ?? user['Username'] ?? user['User_Name'] ?? 'Unknown';
    int id = user['id'] ?? user['ID'] ?? user['User_ID'] ?? 0;
    
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
              deleteUser(id);
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
      createUser(result);
    }
  }

  Future<void> _openEditUserPage(BuildContext context, dynamic user, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _UserFormPage(user: user),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      int id = user['id'] ?? user['ID'] ?? user['User_ID'] ?? 0;
      updateUser(id, result);
    }
  }
}

class _UserFormPage extends StatefulWidget {
  final dynamic user;

  const _UserFormPage({this.user});

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
    _usernameController = TextEditingController(text: isEdit ? (widget.user['username'] ?? widget.user['Username'] ?? widget.user['User_Name'] ?? '').toString() : '');
    _passwordController = TextEditingController(text: '');
    _emailController = TextEditingController(text: isEdit ? (widget.user['email'] ?? widget.user['Email'] ?? widget.user['User_Email'] ?? '').toString() : '');
    _isAdmin = isEdit ? (widget.user['role'] ?? widget.user['Role'] ?? widget.user['User_Role'] ?? false) : false;
    _isActive = isEdit ? (widget.user['status'] ?? widget.user['Status'] ?? widget.user['User_Status'] ?? true) : true;
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
                  validator: (value) => (!isEdit && value!.isEmpty) ? 'Please enter password' : null,
                  decoration: InputDecoration(
                    hintText: isEdit ? 'Leave blank to keep current password' : '',
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
                        final payload = {
                          'username': _usernameController.text,
                          'email': _emailController.text,
                          'password': _passwordController.text,
                          'role': _isAdmin,
                          'status': _isActive,
                        };
                        Navigator.pop(context, payload);
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