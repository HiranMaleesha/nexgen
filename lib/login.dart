import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexgen/main.dart';
import 'package:nexgen/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Color(0xFF4A5859), Color(0xFF2E3838)]
                : [Colors.blue.shade100, Colors.blue.shade200],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'NEXGEN',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'HARDWARE',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Color(0xFFFFAB40),
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[600] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[600] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _signIn,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                  ),
                  onPressed: () {
                    // TODO: Implement forgot password functionality
                  },
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text('Create an Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
  String email = _email.text;
  String password = _password.text;

  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      // Check each personal collection for the user's UID
      List<String> collectionNames = ['admin', 'users'];
      String? uid;
      String? collectionName; // Declaring collectionName variable outside the loop

      for (String name in collectionNames) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(name)
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          uid = user.uid;
          collectionName = name; // Assigning the current collection name to collectionName variable
          break;
        }
      }

      if (uid != null && collectionName != null) {
        // Get user document using found UID
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(uid)
            .get();

        // Retrieve role from Firestore document
        String? role = userDoc['role'];

        if (role == 'Admin') {
          // Navigate to admin dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else if (role == 'User') {
          // Navigate to user dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          // Handle case where role is not found
          print('Role not recognized');
        }
      } else {
        // Handle case where user document doesn't exist
        print('User document not found');
      }
    }
  } catch (e) {
    print("Error occurred: $e");
    // Handle error, display error message, etc.
  }
}

}

