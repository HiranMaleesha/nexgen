import 'package:flutter/material.dart';
import 'cartitem.dart';

class CartProvider extends InheritedWidget {
  final List<CartItem> cartItems;
  final Function(CartItem) addItemToCart;

  CartProvider({
    Key? key,
    required Widget child,
    required this.cartItems,
    required this.addItemToCart,
  }) : super(key: key, child: child);

  static CartProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CartProvider>();
  }

  @override
  bool updateShouldNotify(CartProvider oldWidget) {
    return cartItems != oldWidget.cartItems;
  }
}
