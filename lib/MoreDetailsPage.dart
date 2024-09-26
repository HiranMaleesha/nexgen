import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexgen/cart_screen.dart';

import 'models/product_data.dart'; // Import the shared model

class MoreDetailsPage extends StatefulWidget {
  final ProductData productData;

  const MoreDetailsPage({super.key, required this.productData});

  @override
  _MoreDetailsPageState createState() => _MoreDetailsPageState();
}

class _MoreDetailsPageState extends State<MoreDetailsPage> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> decreaseQuantity() async {
    try {
      // Determine the category of the product from its document ID
      String category = '';

      if (widget.productData.category == "shovels") {
        category = 'shovels';
      } else if (widget.productData.category == "rakes") {
        category = 'rakes';
      } else if (widget.productData.category == "hoses") {
        category = 'hoses';
      } else if (widget.productData.category == "gloves") {
        category = 'gloves';
      } else if (widget.productData.category == "hammers") {
        category = 'hammers';
      } else if (widget.productData.category == "screrdrivers") {
        category = 'screwdrivers';
      } else if (widget.productData.category == "wranches") {
        category = 'wrenches';
      } else if (widget.productData.category == "pliers") {
        category = 'pliers';
      } else if (widget.productData.category == "drills") {
        category = 'drills';
      } else if (widget.productData.category == "nails") {
        category = 'nailes';
      } else if (widget.productData.category == "screws") {
        category = 'screrws';
      } else if (widget.productData.category == "bolts") {
        category = 'bolts';
      } else if (widget.productData.category == "nuts") {
        category = 'nuts';
      } else if (widget.productData.category == "wirings") {
        category = 'wirings';
      } else if (widget.productData.category == "outlets") {
        category = 'outlets';
      } else if (widget.productData.category == "switches") {
        category = 'switches';
      } else if (widget.productData.category == "fixtures") {
        category = 'fixtures';
      } else if (widget.productData.category == "pipes") {
        category = 'pipes';
      } else if (widget.productData.category == "fittings") {
        category = 'fittings';
      } else if (widget.productData.category == "faucets") {
        category = 'faucets';
      } else if (widget.productData.category == "valves") {
        category = 'valves';
      } else if (widget.productData.category == "interiorp") {
        category = 'interiorp';
      } else if (widget.productData.category == "exteriorp") {
        category = 'exteriorp';
      } else if (widget.productData.category == "brushes") {
        category = 'brushes';
      } else if (widget.productData.category == "rollers") {
        category = 'rollers';
      } else if (widget.productData.category == "trays") {
        category = 'trays';
      }

      // Check if category was determined
      if (category.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product category not found.')),
        );
        return;
      }

      // Get reference to product document
      DocumentReference productRef = FirebaseFirestore.instance
          .collection('hardware')
          .doc(category)
          .collection('products')
          .doc(widget.productData.docId);

      int currentQuantity = widget.productData.quantity;
      int reservedQuantity = int.parse(_quantityController.text);

      // Check if reserved quantity is valid
      if (reservedQuantity <= 0 || reservedQuantity > currentQuantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid quantity entered.')),
        );
        return;
      }

      // Update the quantity in Firestore
      await productRef.update({
        'quantity': currentQuantity - reservedQuantity,
      });

      // Update the local state
      setState(() {
        widget.productData.quantity = currentQuantity - reservedQuantity;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity reserved successfully.')),
      );
    } catch (error) {
      print('Error updating quantity: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating quantity: $error')),
      );
    }
  }

  Future<void> _addUserNotification() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      int currentQuantity = widget.productData.quantity;
      int reservedQuantity = int.parse(_quantityController.text);

      // Check if reserved quantity is valid
      if (reservedQuantity <= 0 || reservedQuantity > currentQuantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid quantity entered.')),
        );
        return;
      }

      // Save food details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('cart')
          .doc()
          .set({
        'category': widget.productData.category,
        'quantity': _quantityController.text,
        'productid': widget.productData.docId,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    } catch (error) {
      // Handle any errors that occur during saving
      print('Error Reserving: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Gardening Equipment Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 250,
            child: Image.network(
              widget.productData.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.productData.name,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Price: \$${widget.productData.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18.0, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Quantity Available: ${widget.productData.quantity}',
              style: const TextStyle(fontSize: 18.0, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.productData.details,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Quantity to Reserve',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                decreaseQuantity();
                _addUserNotification();
              },
              child: const Text('Reserve'),
            ),
          ),
        ],
      ),
    );
  }
}
