import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  double _convertToDouble(dynamic price) {
    if (price is String) {
      return double.tryParse(price) ?? 0.0;
    } else if (price is double) {
      return price;
    } else if (price is int) {
      return price.toDouble();
    } else {
      return 0.0;
    }
  }

  int _convertToInt(dynamic price) {
    if (price is String) {
      return int.tryParse(price) ?? 0;
    } else if (price is double) {
      return price.toInt();
    } else if (price is int) {
      return price;
    } else {
      return 0;
    }
  }

  // Fetch cart items and corresponding product details from Firestore
  Future<List<Map<String, dynamic>>> _getCartItemsWithDetails() async {
    QuerySnapshot cartSnapshot = await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('cart')
        .get();

    List<Map<String, dynamic>> cartItems = [];

    // Iterate over each cart item to fetch product details
    for (var doc in cartSnapshot.docs) {
      Map<String, dynamic> cartData = doc.data() as Map<String, dynamic>;
      String category = cartData['category'];
      String productId = cartData['productid'];

      // Fetch the corresponding product details
      DocumentSnapshot productSnapshot = await _firestore
          .collection('hardware')
          .doc(category)
          .collection('products')
          .doc(productId)
          .get();

      if (productSnapshot.exists) {
        Map<String, dynamic> productData =
            productSnapshot.data() as Map<String, dynamic>;

        // Combine cart data and product details
        cartItems.add({
          'id': doc.id, // Cart document ID for deletion
          'category': category,
          'quantity': cartData['quantity'],
          'productid': productId,
          'name': productData['name'],
          'price': productData['price'],
          'details': productData['details'], // Additional product details
        });
      }
    }

    return cartItems;
  }

  // Delete cart item from Firestore and update product quantity
  Future<void> _deleteCartItem(String docId, String category, String productId,
      int cartItemQuantity) async {
    // Fetch the current product quantity
    DocumentSnapshot productSnapshot = await _firestore
        .collection('hardware')
        .doc(category)
        .collection('products')
        .doc(productId)
        .get();

    if (productSnapshot.exists) {
      Map<String, dynamic> productData =
          productSnapshot.data() as Map<String, dynamic>;

      // Convert the product quantity to int
      int currentProductQuantity = _convertToInt(productData['quantity']);

      // Update the product quantity by adding the cart item's quantity back
      int updatedProductQuantity = currentProductQuantity + cartItemQuantity;

      // Update the product's quantity in Firestore
      await _firestore
          .collection('hardware')
          .doc(category)
          .collection('products')
          .doc(productId)
          .update({'quantity': updatedProductQuantity});
    }

    // Delete the cart item from the user's cart
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('cart')
        .doc(docId)
        .delete();

    setState(() {}); // Refresh the UI after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: const Color(0xFF5C6E6C),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getCartItemsWithDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading cart items'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18, color: Color(0xFFD2A96A)),
              ),
            );
          } else {
            final cartItems = snapshot.data!;
            double totalPrice = cartItems.fold(
                0,
                (sum, item) =>
                    sum +
                    (_convertToDouble(item['price']) *
                        int.parse(item['quantity'])));

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _buildCartItem(context, item);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: Rs ${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5C6E6C),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        title: Text(
          item['name'],
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5C6E6C)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['details']),
            Text(
              'Quantity & Price: ${item['quantity']} | Rs ${(_convertToDouble(item['price']) * int.parse(item['quantity'])).toStringAsFixed(2)}',
              style: const TextStyle(color: Color.fromARGB(255, 227, 132, 125)),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Text('Rs ${(_convertToDouble(item['price']) * int.parse(item['quantity'])).toStringAsFixed(2)}'),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              iconSize:
                  40.0, // Set the size of the icon (you can adjust the value)
              onPressed: () {
                // Parse quantity to int
                int cartItemQuantity = int.parse(item['quantity'].toString());

                // Call _deleteCartItem with the required arguments
                _deleteCartItem(
                    item['id'], // Cart document ID
                    item['category'], // Category of the product
                    item['productid'], // Product ID
                    cartItemQuantity // Quantity of the cart item
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
