import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('About Our Shop',
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? const Color.fromARGB(255, 0, 0, 0)
                          : const Color.fromARGB(255, 236, 233, 233))),
              background: Image.asset(
                'assets/Black and White Hardware Gift Certificate.png',
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.dstATop,
                color: isDarkMode
                    ? Colors.black.withOpacity(0.6)
                    : Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionCard(
                  context,
                  'Our Mission',
                  'To provide the highest quality hardware products at competitive prices, '
                      'ensuring customer satisfaction and community support.',
                  Icons.flag,
                  Color(0xFFD2A96A),
                ),
                SizedBox(height: 20),
                _buildSectionCard(
                  context,
                  'Our Vision',
                  'To be the leading hardware supplier, recognized for our customer-centric '
                      'approach, innovative solutions, and commitment to excellence.',
                  Icons.visibility,
                  Color(0xFFD39D87),
                ),
                SizedBox(height: 20),
                _buildSectionCard(
                  context,
                  'Our Values',
                  'Integrity, Innovation, Customer Focus, and Sustainability.',
                  Icons.stars,
                  Color(0xFFA6B7AA),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, String content,
      IconData icon, Color color) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkMode ? Color(0xFF2C3A38) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 30),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Color(0xFF5C6E6C),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Color(0xFF5C6E6C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
