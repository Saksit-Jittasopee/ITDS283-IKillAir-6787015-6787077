import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
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
  
  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    searchProducts('');
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  Future<void> searchProducts(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/search/products?q=$query'));
      if (response.statusCode == 200) {
        setState(() {
          _featuredProducts = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print("Error searching products: $e");
    }
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartScreen()),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationScreen()),
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
              TextField(
                onChanged: (value) => searchProducts(value),
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
                        _buildCategory('All', true),
                        _buildCategory('Personal Air Purify', false),
                        _buildCategory('Car Air Purify', false),
                        _buildCategory('Room Air Purify', false),
                        _buildCategory('Air Quality Monitor', false),
                        _buildCategory('Mask', false),
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
                    return _buildProductCard(
                      context, 
                      product['name'] ?? 'Unknown', 
                      '${product['price']} Baht'
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildProductCard(BuildContext context, String name, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700] : Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(color: Colors.blue, fontSize: 12)),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, size: 16, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartScreen()),
                        );
                      },
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