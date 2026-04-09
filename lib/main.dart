<<<<<<< HEAD
import 'package:flutter/material.dart';

void main() {
=======
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
import 'package:ikillair/pages/loginUser.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<String> profileImageNotifier = ValueNotifier<String>('assets/images/team/dummy.png');
final ValueNotifier<String> usernameNotifier = ValueNotifier<String>('');
final ValueNotifier<String> tokenNotifier = ValueNotifier<String>(''); 
final ValueNotifier<int> userIdNotifier = ValueNotifier<int>(0);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
>>>>>>> 47acc383d183d374b8c849afd334434e002d80ea
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

<<<<<<< HEAD
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
=======
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
          home: const LoginPage(),
        );
      },
>>>>>>> 47acc383d183d374b8c849afd334434e002d80ea
    );
  }
}

<<<<<<< HEAD
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
=======
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
      AdminHome(onNavigate: (index) => setState(() => _selectedIndex = index)),
      const AdminProduct(),
      const AdminUser(),
      const AdminOrder(),
      const AdminNews(),
    ];
>>>>>>> 47acc383d183d374b8c849afd334434e002d80ea
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
=======
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
>>>>>>> 47acc383d183d374b8c849afd334434e002d80ea
      ),
    );
  }
}
