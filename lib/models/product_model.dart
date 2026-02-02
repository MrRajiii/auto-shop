class Product {
  final String id;
  final String name;
  final String price;
  final String category;
  final bool isFeatured;
  final List<String> imageUrls;
  final String? description;
  final Map<String, String>? specifications;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrls,
    this.isFeatured = false,
    required this.description,
    required this.specifications,
  });
}
