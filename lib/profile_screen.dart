import 'package:flutter/material.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF5C6E6C), // Use primary theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFD2A96A), // Avatar background color
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'John Doe', // Replace with actual user name
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5C6E6C), // Text color
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'johndoe@example.com', // Replace with actual user email
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFA6B7AA), // Secondary text color
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileButton(context, 'Edit Profile', const Color(0xFFD2A96A)),
            _buildProfileButton(context, 'Settings', const Color(0xFFD39D87)),
            _buildProfileButton(context, 'Logout', const Color(0xFF5C6E6C)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle button action here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Button color
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

