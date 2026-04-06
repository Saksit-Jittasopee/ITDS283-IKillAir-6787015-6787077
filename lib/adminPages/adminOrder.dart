import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ikillair/adminPages/adminNotification.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminOrder extends StatefulWidget {
  const AdminOrder({super.key});

  @override
  State<AdminOrder> createState() => _AdminOrderState();
}

class _AdminOrderState extends State<AdminOrder> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _orders = [];
  String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    fetchOrders('');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchOrders(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/admin/orders?q=$query'));
      if (response.statusCode == 200) {
        setState(() {
          _orders = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createOrder(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/admin/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        fetchOrders(_currentQuery);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateOrder(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/orders/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        fetchOrders(_currentQuery);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteOrder(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/api/admin/orders/$id'));
      if (response.statusCode == 200) {
        fetchOrders(_currentQuery);
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
                      const Text('Orders\nManagement', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.1)),
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
                      fetchOrders(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search orders',
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
                              SizedBox(width: 120, child: Text("User's name", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 180, child: Text("Product", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 150, child: Text("Order ID", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 100, child: Text("Total", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 150, child: Text("Payment", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 60, child: Text("Edit", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _orders.length,
                            itemBuilder: (context, index) {
                              return _buildOrderRow(_orders[index], index);
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
        onPressed: () => _openAddOrderPage(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildOrderRow(dynamic order, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          const SizedBox(
            width: 60,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.check_circle, color: Colors.green, size: 20),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(order['username'] ?? '', style: const TextStyle(fontSize: 14)),
          ),
          SizedBox(
            width: 180,
            child: Text(order['product'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: 150,
            child: Text(order['orderId'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          SizedBox(
            width: 100,
            child: Text('${order['totalPrice'] ?? 0}', style: const TextStyle(fontSize: 14, color: Colors.blue)),
          ),
          SizedBox(
            width: 150,
            child: Text(order['paymentMethod'] ?? '', style: const TextStyle(fontSize: 14)),
          ),
          SizedBox(
            width: 60,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                onPressed: () => _openEditOrderPage(context, order, index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddOrderPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const _OrderFormPage()),
    );
    if (result != null && result is Map<String, dynamic>) {
      createOrder(result);
    }
  }

  Future<void> _openEditOrderPage(BuildContext context, dynamic order, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _OrderFormPage(order: order),
      ),
    );
    if (result != null) {
      if (result == 'delete') {
        deleteOrder(order['id']);
      } else if (result is Map<String, dynamic>) {
        updateOrder(order['id'], result);
      }
    }
  }
}

class _OrderFormPage extends StatefulWidget {
  final dynamic order;

  const _OrderFormPage({this.order});

  @override
  State<_OrderFormPage> createState() => _OrderFormPageState();
}

class _OrderFormPageState extends State<_OrderFormPage> {
  late TextEditingController _usernameController;
  late TextEditingController _productController;
  late TextEditingController _orderIdController;
  late TextEditingController _totalPriceController;
  late TextEditingController _paymentMethodController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bool isEdit = widget.order != null;
    _usernameController = TextEditingController(text: isEdit ? widget.order['username'] : '');
    _productController = TextEditingController(text: isEdit ? widget.order['product'] : '');
    _orderIdController = TextEditingController(text: isEdit ? widget.order['orderId'] : DateTime.now().millisecondsSinceEpoch.toString());
    _totalPriceController = TextEditingController(text: isEdit ? widget.order['totalPrice'].toString() : '');
    _paymentMethodController = TextEditingController(text: isEdit ? widget.order['paymentMethod'] : 'Credit/Debit Card');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _productController.dispose();
    _orderIdController.dispose();
    _totalPriceController.dispose();
    _paymentMethodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.order != null;

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
                        Text(isEdit ? 'Edit Order' : 'Add Order', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    if (isEdit)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Order?'),
                              content: Text('Delete order "${widget.order['orderId']}"?'),
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
                _buildFieldLabel('User\'s Name'),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) => value!.isEmpty ? 'Please enter user name' : null,
                  decoration: _buildInputDecoration(),
                ),
                const SizedBox(height: 20),
                _buildFieldLabel('Product'),
                TextFormField(
                  controller: _productController,
                  validator: (value) => value!.isEmpty ? 'Please enter product' : null,
                  decoration: _buildInputDecoration(),
                ),
                const SizedBox(height: 20),
                _buildFieldLabel('Total Price'),
                TextFormField(
                  controller: _totalPriceController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter total price' : null,
                  decoration: _buildInputDecoration(),
                ),
                const SizedBox(height: 20),
                _buildFieldLabel('Payment Method'),
                TextFormField(
                  controller: _paymentMethodController,
                  validator: (value) => value!.isEmpty ? 'Please enter method' : null,
                  decoration: _buildInputDecoration(),
                ),
                const SizedBox(height: 20),
                _buildFieldLabel('Order ID'),
                TextFormField(
                  controller: _orderIdController,
                  validator: (value) => value!.isEmpty ? 'Please enter order ID' : null,
                  decoration: _buildInputDecoration(),
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
                          'product': _productController.text,
                          'orderId': _orderIdController.text,
                          'totalPrice': double.tryParse(_totalPriceController.text) ?? 0.0,
                          'paymentMethod': _paymentMethodController.text,
                        };
                        Navigator.pop(context, payload);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(isEdit ? 'SAVE CHANGES' : 'ADD ORDER', style: const TextStyle(fontWeight: FontWeight.bold)),
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

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }
}