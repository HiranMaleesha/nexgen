import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexgen/auth_service.dart';
import 'package:nexgen/edit_profile_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        final data = docSnapshot.data();
        if (data != null) {
          setState(() {
            _profileImageUrl = data['profileImageUrl'];
            _userData = data;
          });
        }
      } catch (e) {
        print('Error fetching profile data: $e');
      }
    }
  }

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
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                      ? Image.network(
                          _profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Theme.of(context).primaryColor,
                              child: Icon(Icons.person,
                                  size: 100, color: Colors.white),
                            );
                          },
                        )
                      : Container(
                          color: Theme.of(context).primaryColor,
                          child: Icon(Icons.person,
                              size: 100, color: Colors.white),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          isDarkMode
                              ? Colors.black.withOpacity(0.7)
                              : Colors.white.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userData['Name'] ?? 'Your Name',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 24),
                  _buildInfoCard(context, isDarkMode),
                  SizedBox(height: 24),
                  _buildActionButtons(context, isDarkMode),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, bool isDarkMode) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Divider(color: isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            _buildInfoRow(context, Icons.contact_page, 'Full Name',
                _userData['Name'] ?? 'N/A'),
            _buildInfoRow(
                context, Icons.email, 'Email', _userData['Email'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey)),
                Text(value, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        _buildButton(
          context,
          'Edit Profile',
          Icons.edit,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          ),
          isDarkMode,
        ),
        SizedBox(height: 12),
        _buildButton(
          context,
          'Settings',
          Icons.settings,
          () {
            // Navigate to Settings
          },
          isDarkMode,
        ),
        SizedBox(height: 12),
        _buildButton(
          context,
          'Logout',
          Icons.exit_to_app,
          () => _handleLogout(context),
          isDarkMode,
          isLogout: true,
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String title, IconData icon,
      VoidCallback onPressed, bool isDarkMode,
      {bool isLogout = false}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        foregroundColor: isLogout
            ? (isDarkMode ? Colors.white : Colors.red)
            : (isDarkMode ? Colors.black : Colors.white),
        backgroundColor: isLogout
            ? (isDarkMode ? Colors.red : Colors.white)
            : Theme.of(context).colorScheme.secondary,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size(double.infinity, 50),
        elevation: 0,
        side: isLogout && !isDarkMode
            ? BorderSide(color: Colors.red)
            : BorderSide.none,
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    await _authService.signOut(context);
  }
}
