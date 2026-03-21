import 'package:flutter/material.dart';
import 'package:ikillair/adminPages/adminHomePage.dart';
import 'package:ikillair/adminPages/adminNews.dart';
import 'package:ikillair/adminPages/adminOrder.dart';
import 'package:ikillair/adminPages/adminProduct.dart';
import 'package:ikillair/adminPages/adminUser.dart';
import 'package:ikillair/pages/homeScreen.dart';
import 'package:ikillair/pages/newsScreen.dart';
import 'package:ikillair/pages/pollutionScreen.dart';
import 'package:ikillair/pages/weatherScreen.dart';
import 'package:ikillair/pages/productScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IKillAir App',
      home: MainContainer(isAdmin: false),
    );
  }
}

class MainContainer extends StatefulWidget {
  final bool isAdmin;
  
  const MainContainer({super.key, this.isAdmin = false});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;

  late final List<Widget> _userPages;
  late final List<Widget> _adminPages;

  @override
  void initState() {
    super.initState();
    
    _userPages = [
      const HomeScreen(),
      const ProductScreen(),
      const PollutionScreen(),
      const WeatherScreen(),
      const NewsScreen(),
    ];

    _adminPages = [
      const AdminHome(),
      const AdminProduct(),
      const AdminUser(),
      const AdminOrder(),
      const AdminNews(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.isAdmin ? _adminPages : _userPages;

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: widget.isAdmin
            ? const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Product'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Users'),
                BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
                BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), label: 'News'),
              ]
            : const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Product'),
                BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Pollution'),
                BottomNavigationBarItem(icon: Icon(Icons.wb_cloudy_outlined), label: 'Weather'),
                BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), label: 'News'),
              ],
      ),
    );
  }
}