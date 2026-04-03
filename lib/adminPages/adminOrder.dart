import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class AdminOrder extends StatefulWidget {
  const AdminOrder({super.key});

  @override
  State<AdminOrder> createState() => _AdminOrderState();
}

class _AdminOrderState extends State<AdminOrder> {
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _orders = [
    {'id': 1, 'username': 'Suggus17', 'product': 'HealthPro 101', 'orderId': '2786123227904'},
    {'id': 2, 'username': 'Saksit', 'product': 'Super Series', 'orderId': '880087884925'},
    {'id': 3, 'username': 'WISHERCARTs', 'product': 'AT-500', 'orderId': '970896978872'},
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                    width: 750,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          color: const Color(0xFF007BFF),
                          child: Row(
                            children: const [
                              SizedBox(width: 60, child: Text("Status", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 150, child: Text("User's name", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 150, child: Text("Product", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                              SizedBox(width: 250, child: Text("Order's ID", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
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
    );
  }

  Widget _buildOrderRow(Map<String, dynamic> order, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          const SizedBox(
            width: 60,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 20),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(order['username'], style: const TextStyle(fontSize: 14)),
          ),
          SizedBox(
            width: 150,
            child: Text(order['product'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 250,
            child: Text(order['orderId'], style: const TextStyle(fontSize: 14, color: Colors.grey)),
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

  Future<void> _openEditOrderPage(BuildContext context, Map<String, dynamic> order, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _OrderFormPage(order: order, index: index),
      ),
    );

    if (result != null) {
      if (result == 'delete') {
        setState(() {
          _orders.removeAt(index);
        });
      } else if (result is Map<String, dynamic>) {
        setState(() {
          _orders[index] = result;
        });
      }
    }
  }
}

class _OrderFormPage extends StatefulWidget {
  final Map<String, dynamic> order;
  final int index;

  const _OrderFormPage({required this.order, required this.index});

  @override
  State<_OrderFormPage> createState() => _OrderFormPageState();
}

class _OrderFormPageState extends State<_OrderFormPage> {
  late TextEditingController _usernameController;
  late TextEditingController _productController;
  late TextEditingController _orderIdController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.order['username']);
    _productController = TextEditingController(text: widget.order['product']);
    _orderIdController = TextEditingController(text: widget.order['orderId']);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _productController.dispose();
    _orderIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        const Text('Edit Order', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Order?'),
                            content: Text('Are you sure you want to delete order "${widget.order['orderId']}"?'),
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
                const Text('User\'s Name', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) => value!.isEmpty ? 'Please enter user\'s name' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Product', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _productController,
                  validator: (value) => value!.isEmpty ? 'Please enter product' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Order ID', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _orderIdController,
                  validator: (value) => value!.isEmpty ? 'Please enter order ID' : null,
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
                      if (_formKey.currentState!.validate()) {
                        final updatedOrder = {
                          'id': widget.order['id'],
                          'username': _usernameController.text,
                          'product': _productController.text,
                          'orderId': _orderIdController.text,
                        };
                        Navigator.pop(context, updatedOrder);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.bold)),
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