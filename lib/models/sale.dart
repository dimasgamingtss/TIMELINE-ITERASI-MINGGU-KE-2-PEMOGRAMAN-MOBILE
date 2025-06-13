class Sale {
  final int id;
  final int productId;
  final int quantity;
  final double totalAmount;
  final DateTime saleDate;

  Sale({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.totalAmount,
    required this.saleDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'total_amount': totalAmount,
      'sale_date': saleDate.millisecondsSinceEpoch,
    };
  }

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      totalAmount: json['total_amount'].toDouble(),
      saleDate: DateTime.fromMillisecondsSinceEpoch(json['sale_date'] as int),
    );
  }

  Sale copyWith({
    int? id,
    int? productId,
    int? quantity,
    double? totalAmount,
    DateTime? saleDate,
  }) {
    return Sale(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
      saleDate: saleDate ?? this.saleDate,
    );
  }
}
