import 'package:flutter/material.dart';
import 'package:nexgen/cartitem.dart';
import 'package:nexgen/cartprovider.dart'; // Import CartProvider
import 'cart_screen.dart'; // Import the CartScreen

class PlumbingScreen extends StatefulWidget {
  @override
  _PlumbingScreenState createState() => _PlumbingScreenState();
}

class _PlumbingScreenState extends State<PlumbingScreen> {
  final Color primaryColor = Color(0xFFA6B7AA);
  final Color secondaryColor = Color(0xFF5C6E6C);
  final Color accentColor = Color(0xFFD2A96A);
  final Color highlightColor = Color(0xFFD26A5A);

  @override
  Widget build(BuildContext context) {
    final cartProvider = CartProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Plumbing Supplies'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
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
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCategorySection(context, 'Pipes', ['Product 1', 'Product 2', 'Product 3']),
          _buildCategorySection(context, 'Fittings', ['Product 4', 'Product 5', 'Product 6']),
          _buildCategorySection(context, 'Faucets', ['Product 7', 'Product 8', 'Product 9']),
          _buildCategorySection(context, 'Valves', ['Product 10', 'Product 11', 'Product 12']),
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
        child: Container(
          width: 120.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.shopping_bag, size: 50, color: accentColor),
              SizedBox(height: 8.0),
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
              SizedBox(height: 16.0),
              Text('Details about $productName go here.', style: TextStyle(color: primaryColor)),
              SizedBox(height: 16.0),
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
                child: Text('Add to Cart', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
