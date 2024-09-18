import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexgen/profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;
  late Map<String, dynamic> _userData = {};
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateUserDetails();
    _getUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Function to select image from gallery
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload the image to Firebase Storage
      final currentUser = FirebaseAuth.instance.currentUser;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${currentUser!.uid}.jpg');
      await storageRef.putFile(_imageFile!);

      // Get the download URL of the uploaded image
      final imageUrl = await storageRef.getDownloadURL();

      // Save the download URL in Firestore (You need to implement this part)
      // Example:
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'profileImageUrl': imageUrl});
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

  Future<void> _updateUserDetails() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final String uid = currentUser.uid;

        Map<String, dynamic> updateData = {};

        // Check if the text controllers are not empty and add them to the update data

        if (_emailController.text.isNotEmpty) {
          updateData['Email'] = _emailController.text;
        }
        if (_nameController.text.isNotEmpty) {
          updateData['Name'] = _nameController.text;
        }

        // Update Firestore document only if there is data to update
        if (updateData.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update(updateData);

          // Optionally, update the user data stored in the _userData map
          setState(() {
            _userData.addAll(updateData);
          });
        } else {
          print('No data to update');
        }
      } else {
        print('Current user is null');
      }
    } catch (error) {
      // Handle any errors that occur during saving
      print('Error saving data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF4A5859),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A5859), Color(0xFF2E3838)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _selectImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _imageFile != null
                            ? FileImage(
                                _imageFile!) // Use FileImage for local file
                            : _userData['profileImageUrl'] != null
                                ? NetworkImage(_userData[
                                    'profileImageUrl']!) // Use NetworkImage for URL
                                : const NetworkImage(
                                        'https://as2.ftcdn.net/v2/jpg/03/59/58/91/1000_F_359589186_JDLl8dIWoBNf1iqEkHxhUeeOulx0wOC5.jpg')
                                    as ImageProvider, // Default NetworkImage
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFAB40),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap to change profile picture',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText:
                        'Enter Name: ${_userData.containsKey('Name') ? _userData['Name'] : 'Unavalilable'}',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText:
                        'Enter Email: ${_userData.containsKey('Email') ? _userData['Email'] : 'Unavalilable'}',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFFFAB40),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _updateUserDetails();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
