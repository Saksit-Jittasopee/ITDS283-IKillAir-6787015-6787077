import 'package:flutter/material.dart';
import 'package:ikillair/pages/notification.dart';
import 'package:ikillair/pages/profileScreen.dart';

class PollutionScreen extends StatefulWidget {
  const PollutionScreen({super.key});

  @override
  State<PollutionScreen> createState() => _PollutionScreenState();
}

class _PollutionScreenState extends State<PollutionScreen> {
  bool isMyCountry = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: isMyCountry ? Colors.amber : Colors.redAccent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    const Text('AQI', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      isMyCountry ? '92' : '179',
                      style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      isMyCountry ? 'Bangkok, Thailand' : 'Lahore, Pakistan',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      isMyCountry ? 'Status: Clean' : 'Status: Poor',
                      style: const TextStyle(color: Colors.black54),
                    ),
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
                    _buildSensorCard('CO2 Level', isMyCountry ? '130' : '450', 'PPM'),
                    _buildSensorCard('NO2 Level', isMyCountry ? '120' : '210', 'PPM'),
                    _buildSensorCard('NH3 Level', isMyCountry ? '12' : '45', 'PPM'),
                    _buildSensorCard('SO2 Level', isMyCountry ? '120' : '180', 'PPM'),
                  ],
                ),
              )
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
}