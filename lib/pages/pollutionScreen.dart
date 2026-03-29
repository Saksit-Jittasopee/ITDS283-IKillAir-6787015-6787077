import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ikillair/api/waqi_api.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class PollutionScreen extends StatefulWidget {
  const PollutionScreen({super.key});

  @override
  State<PollutionScreen> createState() => _PollutionScreenState();
}

class _PollutionScreenState extends State<PollutionScreen> {
  bool isMyCountry = true;
  bool isLoading = true;
  String currentAqi = "--";
  String aqiStatus = "Loading";
  Color aqiColor = Colors.amber;
  
  String locationName = "Locating...";
  String coLevel = "--";
  String no2Level = "--";
  String o3Level = "--";
  String so2Level = "--";

  List<dynamic> globalRankings = [];
  bool isGlobalLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePositionAndFetchData();
    _fetchGlobalData();
  }

  Future<void> _determinePositionAndFetchData() async {
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
    
    final data = await WAQIapi.fetchAqiByLocation(position.latitude, position.longitude);
    
    if (mounted) {
      setState(() {
        isLoading = false;
        if (data != null) {
          int aqi = data['aqi'] ?? 0;
          currentAqi = aqi.toString();
          
          if (data['city'] != null && data['city']['name'] != null) {
            locationName = data['city']['name'];
          } else {
            locationName = "Unknown Location";
          }

          if (data['iaqi'] != null) {
            var iaqi = data['iaqi'];
            coLevel = iaqi['co'] != null ? iaqi['co']['v'].toString() : "--";
            no2Level = iaqi['no2'] != null ? iaqi['no2']['v'].toString() : "--";
            so2Level = iaqi['so2'] != null ? iaqi['so2']['v'].toString() : "--";
            o3Level = iaqi['o3'] != null ? iaqi['o3']['v'].toString() : "--";
          }

          aqiColor = _getAqiColor(aqi);
          if (aqi <= 50) {
            aqiStatus = "Clean";
          } else if (aqi <= 100) {
            aqiStatus = "Moderate";
          } else if (aqi <= 150) {
            aqiStatus = "Unhealthy for Sensitive Groups";
          } else if (aqi <= 200) {
            aqiStatus = "Unhealthy";
          } else if (aqi <= 300) {
            aqiStatus = "Very Unhealthy";
          } else {
            aqiStatus = "Hazardous";
          }
        } else {
          _setErrorState("Data Not Found");
        }
      });
    }
  }

  Future<void> _fetchGlobalData() async {
    final data = await WAQIapi.fetchGlobalRanking();
    if (mounted) {
      setState(() {
        if (data != null) {
          globalRankings = data;
        }
        isGlobalLoading = false;
      });
    }
  }

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.amber;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.redAccent;
    if (aqi <= 300) return Colors.purple;
    return const Color(0xFF7A1B14);
  }

  void _setErrorState(String message) {
    if (mounted) {
      setState(() {
        isLoading = false;
        currentAqi = "N/A";
        aqiStatus = message;
        aqiColor = Colors.grey;
        locationName = "Location Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pollution', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => isMyCountry = true),
                          child: _buildTab('My Location', isMyCountry),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => isMyCountry = false),
                          child: _buildTab('Global', !isMyCountry),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              Text('Today '),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              isMyCountry ? _buildMyCountryView() : _buildGlobalRanking(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildMyCountryView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: aqiColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : Column(
                    children: [
                      const Text('AQI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text(currentAqi, style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text(
                        locationName, 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      Text('Status: $aqiStatus', style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
          ),
          const SizedBox(height: 30),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildSensorCard('CO Level', coLevel, 'PPM'),
              _buildSensorCard('NO2 Level', no2Level, 'PPM'),
              _buildSensorCard('O3 Level', o3Level, 'PPM'),
              _buildSensorCard('SO2 Level', so2Level, 'PPM'),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSensorCard(String title, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(' $unit', style: const TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalRanking() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          color: const Color(0xFF007BFF),
          child: Row(
            children: const [
              Expanded(flex: 1, child: Text('Rank   ↑', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
              Expanded(flex: 3, child: Text('Major Countries\n/Cities', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
              Expanded(flex: 1, child: Text('US AQI', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
            ],
          ),
        ),
        isGlobalLoading
            ? const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : globalRankings.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('No data available', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: globalRankings.length,
                    itemBuilder: (context, index) {
                      final cityData = globalRankings[index];
                      final cityName = cityData['city'] ?? 'Unknown';
                      final countryName = cityData['country'] ?? 'Unknown';
                      final aqi = cityData['aqi'] ?? 0;
                      
                      return _buildRankingRow('${index + 1}', '$cityName, $countryName', aqi.toString(), _getAqiColor(aqi));
                    },
                  ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildRankingRow(String rank, String city, String aqi, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(rank, style: const TextStyle(fontSize: 14))),
          Expanded(flex: 3, child: Text(city, style: const TextStyle(fontSize: 14, color: Colors.grey))),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  aqi,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}