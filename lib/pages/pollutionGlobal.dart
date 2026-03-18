import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class PollutionScreen extends StatefulWidget {
  const PollutionScreen({super.key});

  @override
  State<PollutionScreen> createState() => _PollutionScreenState();
}

class _PollutionScreenState extends State<PollutionScreen> {
  bool isMyCountry = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Text('22/2/2026 ', style: TextStyle(fontSize: 12)),
                            Icon(Icons.arrow_drop_down, size: 18),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: isMyCountry ? _buildMyCountryView() : _buildGlobalView(),
            ),
          ],
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMyCountryView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: const [
                Text('AQI', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('92', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
                Text('Bangkok, Thailand', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Status: Clean', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.count(
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
          )
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

  Widget _buildGlobalView() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: const BoxDecoration(
            color: Color(0xFF007BFF),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Row(
            children: const [
              Expanded(flex: 2, child: Text('Rank   ↑', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              Expanded(flex: 5, child: Text('Major Countries\n/Cities', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              Expanded(flex: 2, child: Text('US AQI', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildGlobalListItem('1', 'Lahore, Pakistan', '355', const Color(0xFF8B231A)),
              _buildGlobalListItem('2', 'New Delhi, India', '184', Colors.red),
              _buildGlobalListItem('3', 'Kolkata, India', '182', Colors.red),
              _buildGlobalListItem('4', 'Manama, Bahrain', '177', Colors.red),
              _buildGlobalListItem('5', 'Seoul, South Korea', '173', Colors.red),
              _buildGlobalListItem('6', 'Baghdad, Iraq', '172', Colors.red),
              _buildGlobalListItem('7', 'Dhaka, Bangladesh', '171', Colors.red),
              _buildGlobalListItem('8', 'Yangon, Myanmar', '164', Colors.red),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalListItem(String rank, String city, String aqi, Color aqiColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(rank, style: const TextStyle(fontSize: 12))),
          Expanded(flex: 5, child: Text(city, style: const TextStyle(fontSize: 12, color: Colors.black87))),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: aqiColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(aqi, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}