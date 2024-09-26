class ProductData {
  final String name;
  final String details;
  final double price;
  final String imageUrl;
  late final int quantity;
  final String category;
  final String docId;

  ProductData({
    required this.name,
    required this.category,
    required this.details,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.docId,
  });
}
