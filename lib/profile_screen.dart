import 'package:flutter/material.dart';



class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF5C6E6C), // Use primary theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFD2A96A), // Avatar background color
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'John Doe', // Replace with actual user name
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5C6E6C), // Text color
              ),
            ),
            SizedBox(height: 10),
            Text(
              'johndoe@example.com', // Replace with actual user email
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFA6B7AA), // Secondary text color
              ),
            ),
            SizedBox(height: 20),
            _buildProfileButton(context, 'Edit Profile', Color(0xFFD2A96A)),
            _buildProfileButton(context, 'Settings', Color(0xFFD39D87)),
            _buildProfileButton(context, 'Logout', Color(0xFF5C6E6C)),
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
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

