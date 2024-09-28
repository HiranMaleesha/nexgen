import 'dart:async'; // For stream handling

import 'package:flutter/material.dart';
import 'package:nexgen/ElectricalScreen.dart';
import 'package:nexgen/FastenersScreen.dart';
import 'package:nexgen/GardeningScreen.dart';
import 'package:nexgen/PaintScreen.dart';
import 'package:nexgen/PlumbingScreen.dart';
import 'package:nexgen/ToolsScreen.dart';
import 'package:sensors_plus/sensors_plus.dart'; // Import sensors_plus for gyroscope

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPortrait = true; // Tracks orientation
  bool hasGyroscope = true; // Tracks gyroscope availability
  StreamSubscription? _gyroscopeSubscription; // Stream subscription to cancel

  @override
  void initState() {
    super.initState();

    // Check if gyroscope is available by attempting to listen to its stream
    try {
      _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
        // Gyroscope readings for x-axis (left-right tilt) detect orientation
        if (event.x.abs() > event.y.abs()) {
          // Landscape mode if more rotation detected around the x-axis
          setState(() {
            isPortrait = false;
          });
        } else {
          // Portrait mode if y-axis rotation is dominant
          setState(() {
            isPortrait = true;
          });
        }
      });
    } catch (e) {
      // If an error occurs (like no gyroscope), set hasGyroscope to false
      setState(() {
        hasGyroscope = false;
      });
    }
  }

  @override
  void dispose() {
    // Cancel the stream subscription when the widget is disposed
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Image section
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height /
                    4, // 1/4 of the screen height
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/Black and White Hardware Gift Certificate.png'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Orientation icon in the top-right corner
              Positioned(
                right: 60.0, // Adjust to your preference
                top: 130.0, // Adjust to your preference
                child: Icon(
                  hasGyroscope
                      ? (isPortrait
                          ? Icons.screen_lock_portrait
                          : Icons.screen_lock_landscape)
                      : Icons.screen_lock_portrait,
                  color: Colors.white, // Change icon color if needed
                  size: 30.0, // Adjust size as needed
                ),
              ),
            ],
          ),
          // Buttons section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: <Widget>[
                  _buildCategoryButton(context, "Gardening Equiment",
                      'assets/gardening.webp', const GardeningScreen()),
                  _buildCategoryButton(context, "Tools", 'assets/tools.webp',
                      const ToolScreen()),
                  _buildCategoryButton(context, "Fasteners", 'assets/fast.jpg',
                      const FastenersScreen()),
                  _buildCategoryButton(context, "Electrical Supplies",
                      'assets/electric.jpeg', const ElectricalScreen()),
                  _buildCategoryButton(context, "Plumbing Supplies",
                      'assets/plumbing.webp', const PlumbingScreen()),
                  _buildCategoryButton(context, "Paint", 'assets/paint.jpg',
                      const PaintScreen()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, String category, String imagePath, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the respective screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero, // Remove padding inside the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
      ),
      child: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  12.0), // Match the button's rounded corners
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay with text
          Container(
            decoration: BoxDecoration(
              color: Colors.black45, // Semi-transparent overlay
              borderRadius: BorderRadius.circular(
                  12.0), // Match the button's rounded corners
            ),
            alignment: Alignment.center,
            child: Text(
              category,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white, // Text color
                fontWeight: FontWeight.bold, // Bold text
                fontSize: 16.0, // Text size
              ),
            ),
          ),
        ],
      ),
    );
  }
}
