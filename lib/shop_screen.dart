import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final LatLng _shopLocation = const LatLng(37.7749, -122.4194);

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
                      color: isDarkMode ? Colors.white : Colors.black)),
              background: Image.asset(
                'assets/Black and White Hardware Gift Certificate.png',
                fit: BoxFit.cover,
                color: isDarkMode
                    ? Colors.black.withOpacity(0.6)
                    : Colors.white.withOpacity(0.6),
                colorBlendMode: BlendMode.dstATop,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    'Our Mission',
                    'To provide the highest quality hardware products at competitive prices, '
                        'ensuring customer satisfaction and community support.',
                    Icons.flag,
                    isDarkMode
                        ? const Color(0xFFD2A96A)
                        : const Color(0xFF5C6E6C),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Our Vision',
                    'To be the leading hardware supplier, recognized for our customer-centric '
                        'approach, innovative solutions, and commitment to excellence.',
                    Icons.visibility,
                    isDarkMode
                        ? const Color(0xFFD39D87)
                        : const Color(0xFF5C6E6C),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Our Values',
                    'Integrity, Innovation, Customer Focus, and Sustainability.',
                    Icons.star,
                    isDarkMode
                        ? const Color(0xFFA6B7AA)
                        : const Color(0xFF5C6E6C),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Our Location',
                      isDarkMode ? Colors.blue : const Color(0xFF5C6E6C)),
                  const SizedBox(height: 8),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GestureDetector(
                        onTap: () => _launchMaps(
                            _shopLocation.latitude, _shopLocation.longitude),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _shopLocation,
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('shopLocation'),
                              position: _shopLocation,
                              infoWindow: const InfoWindow(
                                title: 'Our Shop',
                                snippet: 'We are here!',
                              ),
                            ),
                          },
                          mapType: MapType.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 3.0,
          width: 80.0,
          color: color,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      String title, String content, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 16.0,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
