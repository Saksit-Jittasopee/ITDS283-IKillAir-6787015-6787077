import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ikillair/adminPages/adminNotification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminProduct extends StatefulWidget {
  const AdminProduct({super.key});

  @override
  State<AdminProduct> createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
  List<dynamic> _allProducts = [];
  final ScrollController _categoryScrollController = ScrollController();
  String _selectedCategory = 'All';
  String _currentQuery = '';

  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    fetchProducts('', 'All');
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
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

  Future<void> fetchProducts(String query, String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/products?q=$query&category=$category'));
      if (response.statusCode == 200) {
        setState(() {
          _allProducts = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createProduct(Map<String, dynamic> data) async {
    try {
      String? localImagePath = data['imagePath'];
      var uri = Uri.parse('$baseUrl/api/products/admin');
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer ${tokenNotifier.value}';
      request.fields['name'] = data['name'];
      request.fields['price'] = data['price'].toString();
      request.fields['category'] = data['category'];
      if (localImagePath != null &&
          !localImagePath.startsWith('http') &&
          !localImagePath.startsWith('assets/') &&
          !localImagePath.startsWith('/uploads')) {
        var pic = await http.MultipartFile.fromPath('image', localImagePath);
        request.files.add(pic);
      }
      var response = await request.send();
      if (response.statusCode == 201) {
        fetchProducts(_currentQuery, _selectedCategory);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      String? localImagePath = data['imagePath'];
      var uri = Uri.parse('$baseUrl/api/products/admin/$id');
      var request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer ${tokenNotifier.value}';
      request.fields['name'] = data['name'];
      request.fields['price'] = data['price'].toString();
      request.fields['category'] = data['category'];
      if (localImagePath != null &&
          !localImagePath.startsWith('http') &&
          !localImagePath.startsWith('assets/') &&
          !localImagePath.startsWith('/uploads')) {
        var pic = await http.MultipartFile.fromPath('image', localImagePath);
        request.files.add(pic);
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        fetchProducts(_currentQuery, _selectedCategory);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/products/admin/$id'),
        headers: {'Authorization': 'Bearer ${tokenNotifier.value}'},
      );
      if (response.statusCode == 200) {
        fetchProducts(_currentQuery, _selectedCategory);
      }
    } catch (e) {
      print(e);
    }
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Product Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                  setState(() {
                    _currentQuery = value;
                  });
                  fetchProducts(_currentQuery, _selectedCategory);
                },
                decoration: InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.tune),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              Scrollbar(
                controller: _categoryScrollController,
                thumbVisibility: true,
                thickness: 4,
                radius: const Radius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SingleChildScrollView(
                    controller: _categoryScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Row(
                      children: [
                        _buildCategory('All'),
                        _buildCategory('Personal Air Purify'),
                        _buildCategory('Car Air Purify'),
                        _buildCategory('Room Air Purify'),
                        _buildCategory('Air Quality Monitor'),
                        _buildCategory('Mask'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('All products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: _allProducts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final product = _allProducts[index];
                    return _buildProductCard(context, product, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddProductPage(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, dynamic product, int index) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    String name = product['name'] ?? 'Unknown';
    double price = double.tryParse(product['price'].toString()) ?? 0.0;
    String displayPath = getImageUrl(product['imagePath']);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: displayPath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: displayPath.startsWith('assets/')
                            ? Image.asset(displayPath, fit: BoxFit.cover)
                            : displayPath.startsWith('http')
                                ? Image.network(displayPath, fit: BoxFit.cover)
                                : Image.file(File(displayPath), fit: BoxFit.cover),
                      )
                    : Icon(Icons.image, color: isDark ? Colors.grey[400] : Colors.grey[400]),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${price.toStringAsFixed(2)} Baht',
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _openEditProductPage(context, product, index),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_outlined, color: Colors.blue, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String title) {
    bool isSelected = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
        fetchProducts(_currentQuery, _selectedCategory);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
      ),
    );
  }

  Future<void> _openAddProductPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const _ProductFormPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      createProduct(result);
    }
  }

  Future<void> _openEditProductPage(BuildContext context, dynamic product, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ProductFormPage(
          product: product,
          index: index,
        ),
      ),
    );

    if (result != null) {
      if (result is Map<String, dynamic>) {
        updateProduct(product['id'], result);
      } else if (result == 'delete') {
        deleteProduct(product['id']);
      }
    }
  }
}

class _ProductFormPage extends StatefulWidget {
  final dynamic product;
  final int? index;

  const _ProductFormPage({this.product, this.index});

  @override
  State<_ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<_ProductFormPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  String _selectedCategoryForm = 'Room Air Purify';
  String? _imagePath;
  final _formKey = GlobalKey<FormState>();
  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  final List<String> _categoryOptions = [
    'Personal Air Purify',
    'Car Air Purify',
    'Room Air Purify',
    'Air Quality Monitor',
    'Mask'
  ];

  @override
  void initState() {
    super.initState();
    bool isEditMode = widget.product != null;
    _nameController = TextEditingController(text: isEditMode ? widget.product['name'] : '');
    _priceController = TextEditingController(text: isEditMode ? widget.product['price'].toString() : '');
    _imagePath = isEditMode ? widget.product['imagePath'] : null;
    if (isEditMode && widget.product['category'] != null && _categoryOptions.contains(widget.product['category'])) {
      _selectedCategoryForm = widget.product['category'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
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

  @override
  Widget build(BuildContext context) {
    bool isEditMode = widget.product != null;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
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
                        Text(
                          isEditMode ? 'Edit Product' : 'Add Product',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (isEditMode)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Product?'),
                              content: Text('Are you sure you want to delete "${widget.product['name']}"?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context, 'delete');
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: displayPath.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: displayPath.startsWith('assets/')
                                    ? Image.asset(displayPath, fit: BoxFit.cover)
                                    : displayPath.startsWith('http')
                                        ? Image.network(displayPath, fit: BoxFit.cover)
                                        : Image.file(File(displayPath), fit: BoxFit.cover),
                              )
                            : Icon(Icons.image_outlined, size: 50, color: isDark ? Colors.grey[400] : Colors.grey[400]),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt_outlined, size: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildFieldLabel('Product Name'),
                TextFormField(
                  controller: _nameController,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter product name' : null,
                  decoration: _buildInputDecoration(hint: 'Enter product name', isDark: isDark),
                ),
                const SizedBox(height: 20),
                _buildFieldLabel('Category'),
                DropdownButtonFormField<String>(
                  value: _selectedCategoryForm,
                  decoration: _buildInputDecoration(hint: 'Select category', isDark: isDark),
                  items: _categoryOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategoryForm = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildFieldLabel('Price (Baht)'),
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter product price';
                    if (double.tryParse(value) == null) return 'Please enter a valid number';
                    return null;
                  },
                  decoration: _buildInputDecoration(hint: 'Enter product price', isDark: isDark),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final payload = {
                          'name': _nameController.text,
                          'price': double.parse(_priceController.text),
                          'category': _selectedCategoryForm,
                          'imagePath': _imagePath,
                        };
                        Navigator.pop(context, payload);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      isEditMode ? 'SUBMIT' : 'ADD PRODUCT',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
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

  InputDecoration _buildInputDecoration({required String hint, required bool isDark}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300)),
    );
  }
}