import 'package:flutter/material.dart';
import 'package:nexgen/cartitem.dart';
import 'package:nexgen/cartprovider.dart'; // Import CartProvider
import 'cart_screen.dart'; // Import the CartScreen

class ToolScreen extends StatefulWidget {
  const ToolScreen({super.key});

  @override
  _ToolScreenState createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  // Define the colors
  final Color primaryColor = const Color(0xFFA6B7AA);
  final Color secondaryColor = const Color(0xFF5C6E6C);
  final Color accentColor = const Color(0xFFD2A96A);
  final Color highlightColor = const Color(0xFFD26A5A);

  @override
  Widget build(BuildContext context) {
    final cartProvider = CartProvider.of(context); // Access the CartProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartItems: cartProvider!.cartItems),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _buildCategorySection(context, 'Hammers', ['Hammer 1', 'Hammer 2', 'Hammer 3', 'Hammer 4', 'Hammer 5', 'Hammer 6']),
          _buildCategorySection(context, 'Screwdrivers', ['Screwdriver 1', 'Screwdriver 2', 'Screwdriver 3', 'Screwdriver 4', 'Screwdriver 5', 'Screwdriver 6']),
          _buildCategorySection(context, 'Wrenches', ['Wrench 1', 'Wrench 2', 'Wrench 3', 'Wrench 4', 'Wrench 5', 'Wrench 6']),
          _buildCategorySection(context, 'Pliers', ['Plier 1', 'Plier 2', 'Plier 3', 'Plier 4', 'Plier 5', 'Plier 6']),
          _buildCategorySection(context, 'Drills', ['Drill 1', 'Drill 2', 'Drill 3', 'Drill 4', 'Drill 5', 'Drill 6']),
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
    final cartProvider = CartProvider.of(context); // Access the CartProvider

    return GestureDetector(
      onTap: () {
        _showProductDetails(context, productName, cartProvider!); // Pass the CartProvider
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
