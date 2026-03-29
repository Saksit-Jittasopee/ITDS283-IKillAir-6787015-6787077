import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  
  String currentDate = "";
  String currentTime = "";

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
          final city = data['city'] ?? "Unknown";
          final country = data['country'] ?? "";
          locationName = "$city, $country";

          if (data['current'] != null && data['current']['weather'] != null) {
            final weather = data['current']['weather'];
            temperature = weather['tp'] != null ? weather['tp'].toString() : "--";
            humidity = weather['hu'] != null ? '${weather['hu']}%' : "--";
            
            if (weather['ws'] != null) {
              double wsMs = (weather['ws'] as num).toDouble();
              double wsKmh = wsMs * 3.6;
              windSpeed = '${wsKmh.toStringAsFixed(1)} km/h';
            }

            weatherCondition = "Updated";
          }
        } else {
          _setErrorState("Data Not Found");
        }
      });
    }
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
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage('/assets/images/team/Saksit.jpg'),
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
                            _weatherDetail(Icons.nightlight_round, weatherCondition),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _hourlyCard('Now', Icons.nightlight_round, '$temperature°', true),
                  _hourlyCard('00:00', Icons.umbrella_outlined, '25°', false),
                  _hourlyCard('05:00', Icons.cloud_outlined, '27°', false),
                  _hourlyCard('10:00', Icons.wb_sunny_outlined, '33°', false),
                  _hourlyCard('15:00', Icons.wb_sunny_outlined, '34°', false),
                ],
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