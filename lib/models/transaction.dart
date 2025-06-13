class Transaction {
  final String id;
  final DateTime date;
  final double totalPrice;
  final String userId;
  final List<TransactionItem> items;

  Transaction({
    required this.id,
    required this.date,
    required this.totalPrice,
    required this.userId,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'totalPrice': totalPrice,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      date: DateTime.parse(json['date']),
      totalPrice: json['totalPrice'].toDouble(),
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => TransactionItem.fromJson(item))
          .toList(),
    );
  }
}

class TransactionItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;

  TransactionItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      productId: json['productId'],
      productName: json['productName'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      subtotal: json['subtotal'].toDouble(),
    );
  }
} 