import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminProduct extends StatefulWidget {
  const AdminProduct({super.key});

  @override
  State<AdminProduct> createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
  List<Map<String, dynamic>> _allProducts = [
    {'id': 1, 'name': 'HealthPro 101', 'price': 1000.00, 'category': 'Room Air Purify', 'imagePath': null},
    {'id': 2, 'name': 'Super Series', 'price': 1500.00, 'category': 'Car Air Purify', 'imagePath': null},
    {'id': 3, 'name': 'AT-500', 'price': 5900.00, 'category': 'Personal Air Purify', 'imagePath': null},
    {'id': 4, 'name': 'RZD-Airclean', 'price': 9990.50, 'category': 'Air Quality Monitor', 'imagePath': null},
    {'id': 5, 'name': 'Super Air', 'price': 12000.00, 'category': 'Room Air Purify', 'imagePath': null},
    {'id': 6, 'name': 'Health Mask', 'price': 150.00, 'category': 'Mask', 'imagePath': null},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // นำ backgroundColor: Colors.white ออก เพื่อให้ปรับตาม Theme
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
                  hintText: 'Search products',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.tune),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategory('All', true),
                    _buildCategory('Personal Air Purify', false),
                    _buildCategory('Car Air Purify', false),
                    _buildCategory('Room Air Purify', false),
                    _buildCategory('Air Quality Monitor', false),
                    _buildCategory('Mask', false),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product, int index) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    String name = product['name'] ?? 'Unknown';
    double price = (product['price'] ?? 0.0).toDouble();
    String? imagePath = product['imagePath'];

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
                child: imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: imagePath.startsWith('assets/')
                            ? Image.asset(imagePath, fit: BoxFit.cover)
                            : Image.file(File(imagePath), fit: BoxFit.cover),
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

  Widget _buildCategory(String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
    );
  }

  Future<void> _openAddProductPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const _ProductFormPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final newId = _allProducts.isEmpty ? 1 : _allProducts.map((p) => p['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
        result['id'] = newId;
        _allProducts.add(result);
      });
    }
  }

  Future<void> _openEditProductPage(BuildContext context, Map<String, dynamic> product, int index) async {
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
        setState(() {
          _allProducts[index] = result;
        });
      } else if (result == 'delete') {
        setState(() {
          _allProducts.removeAt(index);
        });
      }
    }
  }
}

class _ProductFormPage extends StatefulWidget {
  final Map<String, dynamic>? product;
  final int? index;

  const _ProductFormPage({this.product, this.index});

  @override
  State<_ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<_ProductFormPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  String? _imagePath;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bool isEditMode = widget.product != null;
    _nameController = TextEditingController(text: isEditMode ? widget.product!['name'] : '');
    _priceController = TextEditingController(text: isEditMode ? widget.product!['price'].toString() : '');
    _imagePath = isEditMode ? widget.product!['imagePath'] : null;
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

  @override
  Widget build(BuildContext context) {
    bool isEditMode = widget.product != null;
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
                              content: Text('Are you sure you want to delete "${widget.product!['name']}"?'),
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
                        child: _imagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: _imagePath!.startsWith('assets/')
                                    ? Image.asset(_imagePath!, fit: BoxFit.cover)
                                    : Image.file(File(_imagePath!), fit: BoxFit.cover),
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
                  decoration: _buildInputDecoration(hint: 'Enter product name'),
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
                  decoration: _buildInputDecoration(hint: 'Enter product price'),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedProduct = {
                          'id': isEditMode ? widget.product!['id'] : null,
                          'name': _nameController.text,
                          'price': double.parse(_priceController.text),
                          'category': isEditMode ? widget.product!['category'] : 'Room Air Purify',
                          'imagePath': _imagePath,
                        };
                        Navigator.pop(context, updatedProduct);
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

  InputDecoration _buildInputDecoration({required String hint}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }
}