class Product {
  final String id;
  final String name;
  final double price;
  int stock;
  final String userId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'userId': userId,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      stock: json['stock'],
      userId: json['userId'],
    );
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? stock,
    String? userId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      userId: userId ?? this.userId,
    );
  }
} 