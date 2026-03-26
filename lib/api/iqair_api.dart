import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for jsonDecode

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AQI & PM2.5 Forecast',
      home: ApiFetchPage(),
    );
  }
}

class ApiFetchPage extends StatefulWidget {
  const ApiFetchPage({super.key});

  @override
  _ApiFetchPageState createState() => _ApiFetchPageState();
}

class _ApiFetchPageState extends State<ApiFetchPage> {
  String _response = '';
  bool _loading = false;
  String _aqi = '';
  String _forecastText = '';

  final List<String> _city = ['bangkok', 'shanghai', 'tokyo', 'london', 'newyork'];
  String _selectedCity = 'shanghai';

  final List<String> _country = ['us', 'uk', 'thailand', 'japan', 'china'];

  Future<void> fetchData() async {
    setState(() {
      _loading = true;
      _response = '';
      _aqi = '';
      _forecastText = '';
    });

    await Future.delayed(Duration(seconds: 1)); // Simulated delay

    String token = "YOUR_API_KEY"; // Replace with your token
    String url = "http://api.airvisual.com/v2/city=$_city?country=$_country?key=$token";

    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'];

       
        setState(() {
          _response = const JsonEncoder.withIndent('  ').convert(jsonData);
          _aqi = "AQI : ${data['aqi']}";
          List pm25Forecast = data['forecast']['daily']['pm25'];

          _forecastText = pm25Forecast.take(3).map((item) {
              return "${item['day']}: avg=${item['avg']}, min=${item['max']}, max=${item['min']})";
            }).join('\n');
        });
      } else {
        setState(() {
          _response = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Exception: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AQI & PM2.5 Forecast'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for city selection
            DropdownButton<String>(
              value: _selectedCity,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue!;
                });
              },
              items: _city.map<DropdownMenuItem<String>>((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city[0].toUpperCase() + city.substring(1)),
                );
              }).toList(),
            ),
            SizedBox(height: 10),

            // Button with spinner
            ElevatedButton(
              onPressed: _loading ? null : fetchData,
              child: _loading ? RotatingHourglass() : Text('Fetch Data'),
            ),
            SizedBox(height: 20),

            // AQI display
            if (_aqi.isNotEmpty) ...[
              Text(_aqi, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
            ],

            // Forecast display
            if (_forecastText.isNotEmpty) ...[
              Text("PM2.5 Forecast (next 3 days):", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_forecastText),
              SizedBox(height: 20),
            ],

            // Raw JSON
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(_response),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RotatingHourglass extends StatefulWidget {
  const RotatingHourglass({super.key});

  @override
  _RotatingHourglassState createState() => _RotatingHourglassState();
}

class _RotatingHourglassState extends State<RotatingHourglass>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(Icons.hourglass_top, color: Colors.white),
    );
  }
}
