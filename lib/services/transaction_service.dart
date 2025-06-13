import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/product.dart';
import 'product_service.dart';

class TransactionService {
  static const String _transactionsKey = 'transactions';

  // Buat transaksi baru
  static Future<bool> createTransaction(
    List<TransactionItem> items,
    String userId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
      
      final totalPrice = items.fold(0.0, (sum, item) => sum + item.subtotal);
      
      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        totalPrice: totalPrice,
        userId: userId,
        items: items,
      );

      transactionsJson.add(jsonEncode(newTransaction.toJson()));
      await prefs.setStringList(_transactionsKey, transactionsJson);
      
      // Update stok produk
      for (TransactionItem item in items) {
        final product = await ProductService.getProductById(item.productId);
        if (product != null) {
          final newStock = product.stock - item.quantity;
          await ProductService.updateProductStock(item.productId, newStock);
        }
      }
      
      return true;
    } catch (e) {
      print('Error creating transaction: $e');
      return false;
    }
  }

  // Dapatkan riwayat transaksi untuk user tertentu
  static Future<List<Transaction>> getTransactions(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
      
      final transactions = <Transaction>[];
      for (String transactionJson in transactionsJson) {
        final transaction = Transaction.fromJson(jsonDecode(transactionJson));
        if (transaction.userId == userId) {
          transactions.add(transaction);
        }
      }
      
      // Urutkan berdasarkan tanggal (terbaru di atas)
      transactions.sort((a, b) => b.date.compareTo(a.date));
      
      return transactions;
    } catch (e) {
      print('Error getting transactions: $e');
      return [];
    }
  }

  // Hitung total penjualan harian
  static Future<double> getDailySales(String userId) async {
    try {
      final today = DateTime.now();
      final transactions = await getTransactions(userId);
      
      double totalSales = 0.0;
      for (Transaction transaction in transactions) {
        if (transaction.date.year == today.year &&
            transaction.date.month == today.month &&
            transaction.date.day == today.day) {
          totalSales += transaction.totalPrice;
        }
      }
      
      return totalSales;
    } catch (e) {
      print('Error calculating daily sales: $e');
      return 0.0;
    }
  }
} 