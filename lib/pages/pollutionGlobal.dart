import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class PollutionGlobal extends StatefulWidget {
  const PollutionGlobal({super.key});

  @override
  State<PollutionGlobal> createState() => _PollutionGlobalState();
}

class _PollutionGlobalState extends State<PollutionGlobal> {
  bool isGlobal = true;

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
                          const Text(
                            'Pollution',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.location_on, color: Color(0xFF007BFF), size: 18),
                              Text(
                                ' Bangkok, Thailand',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
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
                            icon: const Icon(Icons.notifications_none, size: 30),
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
                              radius: 22,
                              backgroundImage: NetworkImage('/assets/images/team/Saksit.jpg'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      _buildTabButton('My Country', !isGlobal),
                      const SizedBox(width: 12),
                      _buildTabButton('Global', isGlobal),
                      const Spacer(),
                      _buildDatePicker(),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: isGlobal ? _buildGlobalRanking() : _buildMyCountryContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isGlobal = label == 'Global';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007BFF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: const [
          Text('22/2/2026 ', style: TextStyle(fontSize: 13)),
          Icon(Icons.arrow_drop_down, size: 20),
        ],
      ),
    );
  }

  Widget _buildGlobalRanking() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 0),
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
        Expanded(
          child: ListView(
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
        ),
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

  Widget _buildMyCountryContent() {
    return const Center(child: Text('My Country View Content'));
  }
}