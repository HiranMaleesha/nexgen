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
import 'package:nexgen/app_theme.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(HardwareShopApp());
}

class HardwareShopApp extends StatelessWidget {
  final List<CartItem> cartItems = [];

  HardwareShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CartProvider(
      cartItems: cartItems,
      addItemToCart: (CartItem item) {
        cartItems.add(item);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hardware Shop',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // This will use the system theme
        home: LoginScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Access cartProvider to get the shared cartItems
    final cartProvider = CartProvider.of(context);

    final List<Widget> pages = [
      HomeScreen(),
      ShopScreen(),
      CartScreen(
          cartItems:
              cartProvider!.cartItems), // Pass the cart items to CartScreen
      ProfileScreen(),
    ];

    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
