class Product {
  final int productId;
  final String title;
  final String productDescription;
  final num price;
  final double? rating;
  final String? imageUrl;
  final List<String> images;
  final int isAvailableForSale;

  Product({
    required this.productId,
    required this.title,
    required this.productDescription,
    required this.price,
    this.rating,
    this.imageUrl,
    required this.images,
    required this.isAvailableForSale,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] as int,
      title: json['title'] as String,
      productDescription: json['productDescription'] as String,
      price: (json['price'] as num),
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      imageUrl: json['imageUrl'] as String?,
      images: List<String>.from(json['images'] as List),
      isAvailableForSale: json['isAvailableForSale'] as int,
    );
  }
}
