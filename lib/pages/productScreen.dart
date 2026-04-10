import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/cartScreen.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<dynamic> _featuredProducts = [];
  final ScrollController _categoryScrollController = ScrollController();
  String _selectedCategory = 'All';
  String _currentQuery = '';
  String baseUrl = Platform.isAndroid ? 'https://jiblee.arlifzs.site' : 'http://10.0.2.2:3001';

  @override
  void initState() {
    super.initState();
    searchProducts('', 'All');
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
          'Authorization': 'Bearer ${dotenv.env['JWT_SECRET'] ?? ''}', 
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

  Future<void> searchProducts(String query, String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/products?q=$query&category=$category'));
      if (response.statusCode == 200) {
        setState(() {
          _featuredProducts = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _addToCart(dynamic product) {
    setState(() {
      int existingIndex = globalUserCart.indexWhere((item) => item['id'] == product['id']);
      if (existingIndex >= 0) {
        globalUserCart[existingIndex]['qty'] += 1;
      } else {
        globalUserCart.add({
          'id': product['id'],
          'name': product['name'] ?? product['Pro_Name'],
          'price': product['price'] ?? product['Pro_Price'],
          'qty': 1,
        });
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart'), duration: Duration(seconds: 1)));
  }

  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    
    if (path.startsWith('Images/') || path.startsWith('images/')) {
      String filename = path.split('/').last;
      return 'assets/images/Products/$filename';
    }
    
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
                  const Text('Product', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                        },
                        icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                      ),
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
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  _currentQuery = value;
                  searchProducts(_currentQuery, _selectedCategory);
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
              const Text('Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
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
              const Text('Featured products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _featuredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _featuredProducts[index];
                    return _buildProductCard(context, product);
                  },
                ),
              ),
            ],
          ),
        ),
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
        searchProducts(_currentQuery, _selectedCategory);
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

  Widget _buildProductCard(BuildContext context, dynamic product) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    String name = product['name'] ?? product['Pro_Name'] ?? 'Unknown';
    double rawPrice = double.tryParse((product['price'] ?? product['Pro_Price'] ?? 0).toString()) ?? 0.0;
    String price = '${rawPrice.toStringAsFixed(2)} Baht';
    
    String rawPath = product['image'] ?? product['Pro_Img'] ?? '';
    String displayPath = getImageUrl(rawPath);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: displayPath.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: displayPath.startsWith('assets/')
                          ? Image.asset(displayPath, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: Colors.grey[400]))
                          : displayPath.startsWith('http')
                              ? Image.network(displayPath, fit: BoxFit.cover)
                              : Image.file(File(displayPath), fit: BoxFit.cover),
                    )
                  : Icon(Icons.image, size: 50, color: isDark ? Colors.grey[400] : Colors.grey[400]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name, 
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        price, 
                        style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.add_shopping_cart, size: 20, color: Colors.blue),
                      onPressed: () => _addToCart(product),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}