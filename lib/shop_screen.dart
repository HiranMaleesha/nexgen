import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Our Shop'),
        backgroundColor: const Color(0xFF5C6E6C), // Primary color for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Our Mission', const Color(0xFFD2A96A)),
            const SizedBox(height: 10),
            const Text(
              'To provide the highest quality hardware products at competitive prices, '
              'ensuring customer satisfaction and community support.',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF5C6E6C), // Main text color
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader('Our Vision', const Color(0xFFD39D87)),
            const SizedBox(height: 10),
            const Text(
              'To be the leading hardware supplier, recognized for our customer-centric '
              'approach, innovative solutions, and commitment to excellence.',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF5C6E6C), // Main text color
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader('Our Values', const Color(0xFFA6B7AA)),
            const SizedBox(height: 10),
            const Text(
              'Integrity, Innovation, Customer Focus, and Sustainability.',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF5C6E6C), // Main text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color underlineColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5C6E6C), // Header text color
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          height: 3.0,
          width: 80.0,
          color: underlineColor, // Color for underline
        ),
      ],
    );
  }
}
