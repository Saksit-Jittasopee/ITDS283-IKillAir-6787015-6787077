import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';
import 'package:ikillair/api/iqair_api.dart';

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

  @override
  void initState() {
    super.initState();
    _loadAqiData();
  }

  Future<void> _loadAqiData() async {
    final data = await IqAirApi.fetchCityAqi();
    
    if (mounted) {
      setState(() {
        isLoading = false;
        if (data != null && data['current'] != null && data['current']['pollution'] != null) {
          int aqi = data['current']['pollution']['aqius'];
          currentAqi = aqi.toString();
          
          if (aqi <= 50) {
            aqiStatus = "Clean";
            aqiColor = Colors.green;
          } else if (aqi <= 100) {
            aqiStatus = "Moderate";
            aqiColor = Colors.amber;
          } else {
            aqiStatus = "Poor";
            aqiColor = Colors.redAccent;
          }
        } else {
          currentAqi = "N/A";
          aqiStatus = "Error";
          aqiColor = Colors.grey;
        }
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Pollution', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                            Row(
                              children: const [
                                Icon(Icons.location_on, color: Colors.blue, size: 16),
                                Text(' Bangkok, Thailand', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ],
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
                          child: _buildTab('My Country', isMyCountry),
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
                              Text('22/2/2026 '),
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
                      const Text('Bangkok, Thailand', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
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
              _buildSensorCard('CO2 Level', '130', 'PPM'),
              _buildSensorCard('NO2 Level', '120', 'PPM'),
              _buildSensorCard('NH3 Level', '12', 'PPM'),
              _buildSensorCard('SO2 Level', '120', 'PPM'),
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
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            _buildRankingRow('1', 'Lahore, Pakistan', '355', const Color(0xFF7A1B14)),
            _buildRankingRow('2', 'New Delhi, India', '184', const Color(0xFFFF2D2D)),
            _buildRankingRow('3', 'Kolkata, India', '182', const Color(0xFFFF2D2D)),
            _buildRankingRow('4', 'Manama, Bahrain', '177', const Color(0xFFFF2D2D)),
            _buildRankingRow('5', 'Seoul, South Korea', '173', const Color(0xFFFF2D2D)),
            _buildRankingRow('6', 'Baghdad, Iraq', '172', const Color(0xFFFF2D2D)),
            _buildRankingRow('7', 'Dhaka, Bangladesh', '171', const Color(0xFFFF2D2D)),
            _buildRankingRow('8', 'Yangon, Myanmar', '164', const Color(0xFFFF2D2D)),
          ],
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