import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Our Shop'),
        backgroundColor: Color(0xFF5C6E6C), // Primary color for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Our Mission', Color(0xFFD2A96A)),
            SizedBox(height: 10),
            Text(
              'To provide the highest quality hardware products at competitive prices, '
              'ensuring customer satisfaction and community support.',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF5C6E6C), // Main text color
              ),
            ),
            SizedBox(height: 30),
            _buildSectionHeader('Our Vision', Color(0xFFD39D87)),
            SizedBox(height: 10),
            Text(
              'To be the leading hardware supplier, recognized for our customer-centric '
              'approach, innovative solutions, and commitment to excellence.',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF5C6E6C), // Main text color
              ),
            ),
            SizedBox(height: 30),
            _buildSectionHeader('Our Values', Color(0xFFA6B7AA)),
            SizedBox(height: 10),
            Text(
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
          style: TextStyle(
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
