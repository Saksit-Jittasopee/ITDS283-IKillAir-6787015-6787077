import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ikillair/adminPages/adminNotification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminNews extends StatefulWidget {
  const AdminNews({super.key});

  @override
  State<AdminNews> createState() => _AdminNewsState();
}

class _AdminNewsState extends State<AdminNews> {
  List<Map<String, dynamic>> _newsList = [
    {
      'id': 1,
      'title': 'ส่องค่าฝุ่นพิษ PM2.5 สัปดาห์นี้ (6-11 มี.ค.) หลายจังหวัดยังน่าเป็นห่วง',
      'link': 'https://www.bbc.com/thai/articles/ckkl7r05z34o',
      'source': '1 Hour Ago - BBC Thailand',
      'imagePath': 'assets/images/news/pm2.5.webp',
    },
    {
      'id': 2,
      'title': 'รัฐบาลออกมาตรการประหยัดพลังงาน พลัส ยกกำลัง 2 ควบคุมราคาสินค้า สั่งผู้ว่าฯ ผ่อนผัน รถส่งน้ำมันวิ่ง 24 ชม.',
      'link': 'https://www.prd.go.th/th/content/category/detail/id/39/iid/486544',
      'source': '4 Hour Ago - กรมประชาสัมพันธ์ PRD',
      'imagePath': 'assets/images/news/reduce_energy.jpg',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('News Management', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminNotification()),
                          );
                        },
                        icon: const Icon(Icons.notifications_none, size: 28),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _newsList.length,
                itemBuilder: (context, index) {
                  return _buildNewsCard(_newsList[index], index);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddNewsPage(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> news, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: news['imagePath'].startsWith('assets/')
                    ? Image.asset(news['imagePath'], fit: BoxFit.cover, width: double.infinity, height: 200)
                    : Image.file(File(news['imagePath']), fit: BoxFit.cover, width: double.infinity, height: 200),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _openEditNewsPage(context, news, index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _confirmDeleteNews(context, index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            news['title'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            news['link'],
            style: const TextStyle(fontSize: 14, color: Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(
            news['source'],
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteNews(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete News?'),
        content: const Text('Are you sure you want to delete this news item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _newsList.removeAt(index);
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddNewsPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const _NewsFormPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final newId = _newsList.isEmpty ? 1 : _newsList.map((n) => n['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
        result['id'] = newId;
        _newsList.add(result);
      });
    }
  }

  Future<void> _openEditNewsPage(BuildContext context, Map<String, dynamic> news, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _NewsFormPage(newsItem: news, index: index),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _newsList[index] = result;
      });
    }
  }
}

class _NewsFormPage extends StatefulWidget {
  final Map<String, dynamic>? newsItem;
  final int? index;

  const _NewsFormPage({this.newsItem, this.index});

  @override
  State<_NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<_NewsFormPage> {
  late TextEditingController _titleController;
  late TextEditingController _linkController;
  late TextEditingController _sourceController;
  String? _imagePath;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bool isEdit = widget.newsItem != null;
    _titleController = TextEditingController(text: isEdit ? widget.newsItem!['title'] : '');
    _linkController = TextEditingController(text: isEdit ? widget.newsItem!['link'] : '');
    _sourceController = TextEditingController(text: isEdit ? widget.newsItem!['source'] : '');
    _imagePath = isEdit ? widget.newsItem!['imagePath'] : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isEdit = widget.newsItem != null;

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
                    Text(isEdit ? 'Edit News' : 'Add News', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _imagePath!.startsWith('assets/')
                                ? Image.asset(_imagePath!, fit: BoxFit.cover)
                                : Image.file(File(_imagePath!), fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, size: 50, color: Colors.grey[400]),
                              const SizedBox(height: 10),
                              Text('Tap to select image', style: TextStyle(color: Colors.grey[500])),
                            ],
                          ),
                  ),
                ),
                if (_imagePath == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Image is required', style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                const SizedBox(height: 30),
                const Text('Title', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  validator: (value) => value!.isEmpty ? 'Please enter title' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Link URL', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _linkController,
                  validator: (value) => value!.isEmpty ? 'Please enter link URL' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Source (e.g. 1 Hour Ago - BBC)', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _sourceController,
                  validator: (value) => value!.isEmpty ? 'Please enter source' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _imagePath != null) {
                        final updatedNews = {
                          'id': isEdit ? widget.newsItem!['id'] : null,
                          'title': _titleController.text,
                          'link': _linkController.text,
                          'source': _sourceController.text,
                          'imagePath': _imagePath,
                        };
                        Navigator.pop(context, updatedNews);
                      } else if (_imagePath == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select an image')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(isEdit ? 'SAVE CHANGES' : 'ADD NEWS', style: const TextStyle(fontWeight: FontWeight.bold)),
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