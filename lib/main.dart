import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<String> profileImageNotifier = ValueNotifier<String>('/assets/images/team/Saksit.jpg');
final ValueNotifier<String> usernameNotifier = ValueNotifier<String>('Saksit');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'IKillAir App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          // เปลี่ยนตรงนี้เป็น true เพื่อเข้าสู่โหมด Admin
          home: const MainContainer(isAdmin: true),
        );
      },
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
      HomeScreen(onNavigate: (index) => setState(() => _selectedIndex = index)),
      const ProductScreen(),
      const PollutionScreen(),
      const WeatherScreen(),
      const NewsScreen(),
    ];

    _adminPages = [
      AdminHome(onNavigate: (index) => setState(() => _selectedIndex = index)), // แก้ไขส่ง onNavigate เข้าไป
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