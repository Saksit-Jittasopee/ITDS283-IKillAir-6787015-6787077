import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ikillair/main.dart';
import 'package:ikillair/api/iqair_api.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = true;
  String locationName = "Locating...";
  String temperature = "--";
  String windSpeed = "--";
  String humidity = "--";
  String weatherCondition = "Loading";
  IconData weatherIcon = Icons.wb_sunny_outlined;
  
  String currentDate = "";
  String currentTime = "";
  List<Map<String, dynamic>> hourlyForecast = [];

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _determinePositionAndFetchWeather();
  }

  void _updateDateTime() {
    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    setState(() {
      currentDate = '${now.day} ${months[now.month - 1]}, ${weekdays[now.weekday - 1]}';
      currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _determinePositionAndFetchWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _setErrorState("Location Disabled");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _setErrorState("Permission Denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _setErrorState("Permission Denied Forever");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    final data = await IqAirApi.fetchWeatherByLocation(position.latitude, position.longitude);
    
    if (mounted) {
      setState(() {
        isLoading = false;
        if (data != null) {
          final state = data['state'] ?? data['city'] ?? "Unknown";
          final country = data['country'] ?? "";
          locationName = country.isNotEmpty ? "$state, $country" : state;

          if (data['current'] != null && data['current']['weather'] != null) {
            final weather = data['current']['weather'];
            int temp = weather['tp'] ?? 0;
            temperature = temp.toString();
            int humid = weather['hu'] ?? 0;
            humidity = '$humid%';
            
            if (weather['ws'] != null) {
              double wsMs = (weather['ws'] as num).toDouble();
              double wsKmh = wsMs * 3.6;
              windSpeed = '${wsKmh.toStringAsFixed(1)} km/h';
            }

            weatherIcon = _getWeatherIcon(temp, humid);
            weatherCondition = _getWeatherStatus(temp, humid);
            _generateMockHourlyForecast(temp);
          }
        } else {
          _setErrorState("Data Not Found");
        }
      });
    }
  }

  void _generateMockHourlyForecast(int currentTemp) {
    final now = DateTime.now();
    hourlyForecast = [];
    
    for (int i = 0; i < 5; i++) {
      final forecastTime = now.add(Duration(hours: i));
      final timeStr = i == 0 ? 'Now' : '${forecastTime.hour.toString().padLeft(2, '0')}:00';
      
      int mockTemp = currentTemp + (i * (i % 2 == 0 ? 1 : -1));
      int mockHumid = 70 + (i * 2); 
      
      hourlyForecast.add({
        'time': timeStr,
        'temp': '$mockTemp°',
        'icon': _getWeatherIcon(mockTemp, mockHumid),
        'isNow': i == 0,
      });
    }
  }

  IconData _getWeatherIcon(int temp, int humid) {
    if (humid > 80) return Icons.umbrella_outlined;
    if (temp < 25) return Icons.cloud_outlined;
    return Icons.wb_sunny_outlined;
  }

  String _getWeatherStatus(int temp, int humid) {
    if (humid > 80) return "Rainy";
    if (temp < 25) return "Cloudy";
    return "Clear";
  }

  void _setErrorState(String message) {
    if (mounted) {
      setState(() {
        isLoading = false;
        locationName = message;
        temperature = "--";
        windSpeed = "--";
        humidity = "--";
        weatherCondition = "Error";
        weatherIcon = Icons.error_outline;
        hourlyForecast = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Weather', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.blue, size: 16),
                            Expanded(
                              child: Text(
                                ' $locationName', 
                                style: const TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
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
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network('/assets/images/weather/Bangkok.webp', fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Today', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(currentDate, style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 10),
                            _weatherDetail(weatherIcon, weatherCondition),
                            _weatherDetail(Icons.air, windSpeed),
                            _weatherDetail(Icons.water_drop_outlined, humidity),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(currentTime, style: const TextStyle(fontSize: 40)),
                            Text('$temperature°', style: const TextStyle(fontSize: 40)),
                          ],
                        )
                      ],
                    ),
              const SizedBox(height: 20),
              if (hourlyForecast.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: hourlyForecast.map((forecast) {
                    return _hourlyCard(
                      forecast['time'], 
                      forecast['icon'], 
                      forecast['temp'], 
                      forecast['isNow']
                    );
                  }).toList(),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _weatherDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          Text(' $text', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _hourlyCard(String time, IconData icon, String temp, bool isNow) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: isNow ? Colors.blue : Colors.blue[400],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 10)),
          const SizedBox(height: 8),
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(temp, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}