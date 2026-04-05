import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ikillair/adminPages/adminNotification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminNews extends StatefulWidget {
  const AdminNews({super.key});

  @override
  State<AdminNews> createState() => _AdminNewsState();
}

class _AdminNewsState extends State<AdminNews> {
  List<dynamic> _newsList = [];
  bool _isLoading = true;
  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/news'));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _newsList = jsonDecode(response.body);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteNewsApi(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/api/admin/news/$id'));
      if (response.statusCode == 200) {
        fetchNews();
      }
    } catch (e) {}
  }

  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('/uploads')) return '$baseUrl$path';
    return path;
  }

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
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _newsList.isEmpty
                      ? const Center(child: Text('No news available'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _newsList.length,
                          itemBuilder: (context, index) {
                            return _buildNewsCard(_newsList[index]);
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

  Widget _buildNewsCard(dynamic news) {
    String displayPath = getImageUrl(news['imagePath']);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: displayPath.startsWith('assets/')
                    ? Image.asset(displayPath, fit: BoxFit.cover, width: double.infinity, height: 200)
                    : displayPath.startsWith('http')
                        ? Image.network(displayPath, fit: BoxFit.cover, width: double.infinity, height: 200)
                        : Image.file(File(displayPath), fit: BoxFit.cover, width: double.infinity, height: 200),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _openEditNewsPage(context, news),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _confirmDeleteNews(context, news['id']),
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
          Text(news['title'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(news['link'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.blue)),
          const SizedBox(height: 10),
          Text(news['source'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  void _confirmDeleteNews(BuildContext context, int id) {
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
              _deleteNewsApi(id);
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
    if (result == true) fetchNews();
  }

  Future<void> _openEditNewsPage(BuildContext context, dynamic news) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _NewsFormPage(newsItem: news)),
    );
    if (result == true) fetchNews();
  }
}

class _NewsFormPage extends StatefulWidget {
  final dynamic newsItem;
  const _NewsFormPage({this.newsItem});

  @override
  State<_NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<_NewsFormPage> {
  late TextEditingController _titleController;
  late TextEditingController _linkController;
  late TextEditingController _sourceController;
  String? _imagePath;
  final _formKey = GlobalKey<FormState>();
  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

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

  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('/uploads')) return '$baseUrl$path';
    return path;
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate() && _imagePath != null) {
      bool isEdit = widget.newsItem != null;
      var uri = Uri.parse(isEdit ? '$baseUrl/api/admin/news/${widget.newsItem['id']}' : '$baseUrl/api/admin/news');
      var request = http.MultipartRequest(isEdit ? 'PUT' : 'POST', uri);

      request.fields['title'] = _titleController.text;
      request.fields['link'] = _linkController.text;
      request.fields['source'] = _sourceController.text;

      if (!_imagePath!.startsWith('http') && !_imagePath!.startsWith('assets/') && !_imagePath!.startsWith('/uploads')) {
        var pic = await http.MultipartFile.fromPath('image', _imagePath!);
        request.files.add(pic);
      }

      try {
        var response = await request.send();
        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pop(context, true);
        }
      } catch (e) {}
    } else if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isEdit = widget.newsItem != null;
    String displayPath = getImageUrl(_imagePath);

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
                    child: displayPath.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: displayPath.startsWith('assets/')
                                ? Image.asset(displayPath, fit: BoxFit.cover)
                                : displayPath.startsWith('http')
                                    ? Image.network(displayPath, fit: BoxFit.cover)
                                    : Image.file(File(displayPath), fit: BoxFit.cover),
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
                    onPressed: _submitData,
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