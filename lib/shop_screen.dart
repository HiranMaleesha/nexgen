import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // Coordinates for the shop's location (example: latitude and longitude)
  final LatLng _shopLocation = const LatLng(37.7749, -122.4194);
  // San Francisco
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
            const SizedBox(height: 5),
            const Text(
              'To provide the highest quality hardware products at competitive prices, '
              'ensuring customer satisfaction and community support.',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF5C6E6C), // Main text color
              ),
            ),
            const SizedBox(height: 15),
            _buildSectionHeader('Our Vision', const Color(0xFFD39D87)),
            const SizedBox(height: 5),
            const Text(
              'To be the leading hardware supplier, recognized for our customer-centric '
              'approach, innovative solutions, and commitment to excellence.',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF5C6E6C), // Main text color
              ),
            ),
            const SizedBox(height: 15),
            _buildSectionHeader('Our Values', const Color(0xFFA6B7AA)),
            const SizedBox(height: 5),
            const Text(
              'Integrity, Innovation, Customer Focus, and Sustainability.',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF5C6E6C), // Main text color
              ),
            ),
            const SizedBox(height: 15),
            _buildSectionHeader(
                'Our Location', const Color.fromARGB(255, 133, 183, 248)),
            const SizedBox(height: 5),
            // Add Google Map here
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _launchMaps(_shopLocation.latitude, _shopLocation.longitude);
                },
                child: Container(
                  height: 300, // Adjust height as necessary
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF5C6E6C)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _shopLocation,
                        zoom: 15, // Adjust zoom level
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
