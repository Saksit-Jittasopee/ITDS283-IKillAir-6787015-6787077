import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/loginUser.dart';
import 'package:ikillair/pages/team.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notification = true;
  late TextEditingController _usernameController;
  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: usernameNotifier.value);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      profileImageNotifier.value = image.path;
    }
  }

  Future<void> _updateProfile() async {
    try {
      final payload = {
        'username': _usernameController.text,
        'imagePath': profileImageNotifier.value,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/api/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_SAVED_TOKEN', 
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        usernameNotifier.value = _usernameController.text;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update profile')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
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
                  const Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      ValueListenableBuilder<String>(
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
                            radius: 40,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: imgProvider,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                          child: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildFieldLabel('Username'),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.edit_outlined),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Location'),
              _buildTextField('Bangkok, Thailand', true),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildSwitchRow('Notification', _notification, Colors.red, (val) => setState(() => _notification = val)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OurTeamScreen()),
                      );
                    },
                    child: const Text(
                      "Our Team",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (context, currentTheme, child) {
                  bool isDarkMode = currentTheme == ThemeMode.dark;
                  return _buildSwitchRow('Theme', isDarkMode, Colors.black, (val) {
                    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                  });
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('SUBMIT', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('LOG OUT', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildTextField(String value, bool showEdit) {
    return TextField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        suffixIcon: showEdit ? const Icon(Icons.edit_outlined) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _buildSwitchRow(String title, bool value, Color activeColor, Function(bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Transform.scale(
          scale: 0.8,
          alignment: Alignment.centerLeft,
          child: Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: activeColor,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}