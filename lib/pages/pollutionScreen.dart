import 'package:flutter/material.dart';

class PollutionScreen extends StatelessWidget {
  const PollutionScreen({super.key});

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
                  const Row(
                    children: [
                      Icon(Icons.notifications_none, size: 28),
                      SizedBox(width: 15),
                      CircleAvatar(radius: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildTab('My Country', true),
                  _buildTab('Global', false),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: const [Text('22/2/2026 '), Icon(Icons.arrow_drop_down)],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(25)),
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
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(color: isSelected ? Colors.blue : Colors.grey[100], borderRadius: BorderRadius.circular(15)),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
    );
  }

  Widget _buildSensorCard(String title, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
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