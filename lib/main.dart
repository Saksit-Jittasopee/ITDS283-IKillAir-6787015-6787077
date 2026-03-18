import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IKillAir App',
      home: const MainContainer(),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ProductScreen(),
    const PollutionScreen(),
    const WeatherScreen(),
    const NewsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
        items: const [
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