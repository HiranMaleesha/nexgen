import 'package:flutter/material.dart';
import 'package:nexgen/cartitem.dart';
import 'package:nexgen/cartprovider.dart';
import 'cart_screen.dart'; // Import the CartScreen

class PaintScreen extends StatefulWidget {
  const PaintScreen({super.key});

  @override
  _PaintScreenState createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  // Define the colors
  final Color primaryColor = const Color(0xFFA6B7AA);
  final Color secondaryColor = const Color(0xFF5C6E6C);
  final Color accentColor = const Color(0xFFD2A96A);
  final Color highlightColor = const Color(0xFFD26A5A);

  @override
  Widget build(BuildContext context) {
    final cartProvider = CartProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paint Supplies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartItems: cartProvider!.cartItems), // Access cart items from provider
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCategorySection(context, 'Interior Paint', ['Interior Paint 1','Interior Paint 2','Interior Paint 3','Interior Paint 4','Interior Paint 5','Interior Paint 6',]),
          _buildCategorySection(context, 'Exterior Paint', ['Exterior Paint 1','Exterior Paint 2','Exterior Paint 3','Exterior Paint 4','Exterior Paint 5','Exterior Paint 6',]),
          _buildCategorySection(context, 'Brushes', ['Brush 1', 'Brush 2', 'Brush 3', 'Brush 4', 'Brush 5', 'Brush 6', ]),
          _buildCategorySection(context, 'Rollers', ['Roller 1','Roller 2','Roller 3','Roller 4','Roller 5','Roller 6',]),
          _buildCategorySection(context, 'Paint Trays', ['Paint Tray 1','Paint Tray 2','Paint Tray 3','Paint Tray 4','Paint Tray 5','Paint Tray 6',]),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String title, List<String> products) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          SizedBox(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(context, products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, String productName) {
    final cartProvider = CartProvider.of(context);

    return GestureDetector(
      onTap: () {
        _showProductDetails(context, productName, cartProvider!);
      },
      child: Card(
        color: secondaryColor,
        child: SizedBox(
          width: 120.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.shopping_bag, size: 50, color: accentColor),
              const SizedBox(height: 8.0),
              Text(productName, textAlign: TextAlign.center, style: TextStyle(color: primaryColor)),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, String productName, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                productName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 16.0),
              Text('Details about $productName go here.', style: TextStyle(color: primaryColor)),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Add the item to the cart using the provider
                  cartProvider.addItemToCart(
                    CartItem(
                      name: productName,
                      details: 'Details about $productName',
                      quantity: 1,
                      price: 10.0, // Set a fixed price or retrieve the actual price
                    ),
                  );

                  Navigator.pop(context); // Close the dialog after adding to cart
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$productName added to cart')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: highlightColor,
                ),
                child: const Text('Add to Cart', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
