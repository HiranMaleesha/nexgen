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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Black and White Hardware Gift Certificate.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.6),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: <Widget>[
                  _buildCategoryButton(context, "Gardening Equipment", 'assets/gardening.webp', GardeningScreen()),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.3),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black45 : Colors.black26,
              borderRadius: BorderRadius.circular(12.0),
            ),
            alignment: Alignment.center,
            child: Text(
              category,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}