import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nexgen/cart_screen.dart';
import 'package:nexgen/cartitem.dart';
import 'package:nexgen/cartprovider.dart';
import 'package:nexgen/firebase_options.dart';
import 'package:nexgen/home_screen.dart';
import 'package:nexgen/navbar.dart';
import 'package:nexgen/profile_screen.dart';
import 'package:nexgen/shop_screen.dart';

import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(HardwareShopApp());
}

class HardwareShopApp extends StatelessWidget {
  final List<CartItem> cartItems = []; // Initialize the cartItems list

  @override
  Widget build(BuildContext context) {
    return CartProvider(
      cartItems: cartItems,
      addItemToCart: (CartItem item) {
        cartItems.add(item);
      },
      child: MaterialApp(
        title: 'Hardware Shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Access cartProvider to get the shared cartItems
    final cartProvider = CartProvider.of(context);

    final List<Widget> _pages = [
      HomeScreen(),
      ShopScreen(),
      CartScreen(cartItems: cartProvider!.cartItems), // Pass the cart items to CartScreen
      ProfileScreen(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
