import 'package:flutter/material.dart';
import 'package:nexgen/ElectricalScreen.dart';
import 'package:nexgen/FastenersScreen.dart';
import 'package:nexgen/GardeningScreen.dart';
import 'package:nexgen/PaintScreen.dart';
import 'package:nexgen/PlumbingScreen.dart';
import 'package:nexgen/ToolsScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Image section
          Container(
            height: MediaQuery.of(context).size.height / 4, // 1/4 of the screen height
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Black and White Hardware Gift Certificate.png'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
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
                  _buildCategoryButton(context, "Gardening Equiment", 'assets/gardening.webp', GardeningScreen()),
                  _buildCategoryButton(context, "Tools", 'assets/tools.webp', ToolScreen()),
                  _buildCategoryButton(context, "Fasteners", 'assets/fast.jpg', FastenersScreen()),
                  _buildCategoryButton(context, "Electrical Supplies", 'assets/electric.jpeg', ElectricalScreen()),
                  _buildCategoryButton(context, "Plumbing Supplies", 'assets/plumbing.webp', PlumbingScreen()),
                  _buildCategoryButton(context, "Paint", 'assets/paint.jpg', PaintScreen()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String category, String imagePath, Widget screen) {
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
              borderRadius: BorderRadius.circular(12.0), // Match the button's rounded corners
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
              borderRadius: BorderRadius.circular(12.0), // Match the button's rounded corners
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
