import 'package:flutter/material.dart';
import 'cartitem.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  CartScreen({required this.cartItems});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Color(0xFF5C6E6C),
      ),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18, color: Color(0xFFD2A96A)),
              ),
            )
          : Column(
              children: [
                // Expand the ListView to take up all available space
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return _buildCartItem(context, item, index);
                    },
                  ),
                ),
                // Padding for the total price and buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5C6E6C),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: Text(
          item.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5C6E6C)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.details),
            Row(
              children: [
                Text('Qty: ${item.quantity}'),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      if (item.quantity > 1) {
                        item.quantity;  
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      item.quantity;  
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  widget.cartItems.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
