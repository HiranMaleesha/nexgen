import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexgen/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  String? _profileImageUrl;
  late Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _getUserData();
  }

  void _loadProfileImage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        final data = docSnapshot.data();
        if (data != null && data.containsKey('profileImageUrl')) {
          setState(() {
            _profileImageUrl = data['profileImageUrl'];
          });
        }
      } catch (e) {
        print('Error fetching profile image URL: $e');
      }
    }
  }

  Future<void> _getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final String uid = currentUser.uid;
      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
          .collection(
              'users') // Assuming user data is stored in the 'users' collection
          .doc(uid) // Use user's UID to retrieve their document
          .get();

      setState(() {
        _userData = userDataSnapshot.data() as Map<String, dynamic>;
      });
    } else {
      print('Current user is null');
    }
  }

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
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFFD2A96A),
              backgroundImage: _profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!)
                  : const AssetImage(
                          'https://as2.ftcdn.net/v2/jpg/03/59/58/91/1000_F_359589186_JDLl8dIWoBNf1iqEkHxhUeeOulx0wOC5.jpg')
                      as ImageProvider, // Cast AssetImage to ImageProvider
            ),
            const SizedBox(height: 20),
            Text(
              _userData.containsKey('Name') ? _userData['Name'] : 'Loading..',
              style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C6E6C)),
            ),
            const SizedBox(height: 10),
            Text(
              _userData.containsKey('Email') ? _userData['Email'] : 'Loading..',
              style: const TextStyle(fontSize: 16.0, color: Color(0xFFA6B7AA)),
            ),
            const SizedBox(height: 20),
            _buildProfileButton(
                context, 'Edit Profile', const Color(0xFFD2A96A)),
            _buildProfileButton(context, 'Settings', const Color(0xFFD39D87)),
            _logOutButton(context, 'Logout', const Color(0xFF5C6E6C)),
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

  Widget _logOutButton(BuildContext context, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          _handleLogout(context);
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

  void _handleLogout(BuildContext context) async {
    await _authService.signOut(context); // Call the signOut method
  }
}
