import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; //ToolScreen
import 'package:nexgen/MoreDetailsPage.dart';
import 'package:nexgen/cart_screen.dart';
import 'package:nexgen/cartprovider.dart';

import 'models/product_data.dart'; // Import the shared ProductData model

class ToolScreen extends StatefulWidget {
  const ToolScreen({super.key});

  @override
  _ToolScreenState createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  final Color primaryColor = const Color(0xFFA6B7AA);
  final Color secondaryColor = const Color(0xFF5C6E6C);
  final Color accentColor = const Color(0xFFD2A96A);
  final Color highlightColor = const Color(0xFFD26A5A);

  late Future<List<ProductData>> _productsFuture;
  List<ProductData> hammers = [];
  List<ProductData> screrdrivers = [];
  List<ProductData> wranches = [];
  List<ProductData> pliers = [];
  List<ProductData> drills = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProductsFromFirestore();
  }

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

  Future<List<ProductData>> fetchProductsFromFirestore() async {
    List<ProductData> products = [];

    QuerySnapshot<Map<String, dynamic>> hammerSnapshot = await FirebaseFirestore
        .instance
        .collection('hardware')
        .doc('hammers')
        .collection('products')
        .get();

    QuerySnapshot<Map<String, dynamic>> screrdriverSnapshot =
        await FirebaseFirestore.instance
            .collection('hardware')
            .doc('screrdrivers')
            .collection('products')
            .get();

    QuerySnapshot<Map<String, dynamic>> wrancheSnapshot =
        await FirebaseFirestore.instance
            .collection('hardware')
            .doc('wranches')
            .collection('products')
            .get();

    QuerySnapshot<Map<String, dynamic>> plierSnapshot = await FirebaseFirestore
        .instance
        .collection('hardware')
        .doc('pliers')
        .collection('products')
        .get();

    QuerySnapshot<Map<String, dynamic>> drillSnapshot = await FirebaseFirestore
        .instance
        .collection('hardware')
        .doc('drills')
        .collection('products')
        .get();

    for (var doc in hammerSnapshot.docs) {
      hammers.add(ProductData(
        name: doc['name'],
        details: doc['details'],
        price: _convertToDouble(doc['price']),
        imageUrl: doc['imageUrl'],
        quantity: _convertToInt(doc['quantity']),
        category: doc['category'],
        docId: doc.id,
      ));
    }

    for (var doc in screrdriverSnapshot.docs) {
      screrdrivers.add(ProductData(
        name: doc['name'],
        details: doc['details'],
        price: _convertToDouble(doc['price']),
        imageUrl: doc['imageUrl'],
        quantity: _convertToInt(doc['quantity']),
        category: doc['category'],
        docId: doc.id,
      ));
    }

    for (var doc in wrancheSnapshot.docs) {
      wranches.add(ProductData(
        name: doc['name'],
        details: doc['details'],
        price: _convertToDouble(doc['price']),
        imageUrl: doc['imageUrl'],
        quantity: _convertToInt(doc['quantity']),
        category: doc['category'],
        docId: doc.id,
      ));
    }

    for (var doc in plierSnapshot.docs) {
      pliers.add(ProductData(
        name: doc['name'],
        details: doc['details'],
        price: _convertToDouble(doc['price']),
        imageUrl: doc['imageUrl'],
        quantity: _convertToInt(doc['quantity']),
        category: doc['category'],
        docId: doc.id,
      ));
    }

    for (var doc in drillSnapshot.docs) {
      drills.add(ProductData(
        name: doc['name'],
        details: doc['details'],
        price: _convertToDouble(doc['price']),
        imageUrl: doc['imageUrl'],
        quantity: _convertToInt(doc['quantity']),
        category: doc['category'],
        docId: doc.id,
      ));
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
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
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ProductData>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return const Center(child: Text('Error loading products'));
          } else {
            return ListView(
              children: <Widget>[
                _buildCategorySection(context, 'Hammers', hammers),
                _buildCategorySection(context, 'Screrdrivers', screrdrivers),
                _buildCategorySection(context, 'Wranches', wranches),
                _buildCategorySection(context, 'Pliers', pliers),
                _buildCategorySection(context, 'Drills', drills),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCategorySection(
      BuildContext context, String title, List<ProductData> products) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black, // Dark background for the section name
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Light text color for contrast
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
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

  Widget _buildProductCard(BuildContext context, ProductData product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoreDetailsPage(productData: product),
          ),
        );
      },
      child: Card(
        color: Colors.white, // Light color for the card
        elevation: 3,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 35, // Adjust card width
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  product.imageUrl,
                  height: 80,
                  width: 80, // Fixed image size
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.details,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Rs ${product.price}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700], // Color for price
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
