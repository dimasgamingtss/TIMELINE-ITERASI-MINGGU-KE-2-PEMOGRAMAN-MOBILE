import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductService {
  static const String _productsKey = 'products';

  // Tambah produk baru
  static Future<bool> addProduct(String name, double price, int stock, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = prefs.getStringList(_productsKey) ?? [];
      
      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        price: price,
        stock: stock,
        userId: userId,
      );

      productsJson.add(jsonEncode(newProduct.toJson()));
      await prefs.setStringList(_productsKey, productsJson);
      
      return true;
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }

  // Dapatkan daftar produk untuk user tertentu
  static Future<List<Product>> getProducts(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = prefs.getStringList(_productsKey) ?? [];
      
      final products = <Product>[];
      for (String productJson in productsJson) {
        final product = Product.fromJson(jsonDecode(productJson));
        if (product.userId == userId) {
          products.add(product);
        }
      }
      
      return products;
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  // Update stok produk
  static Future<bool> updateProductStock(String productId, int newStock) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = prefs.getStringList(_productsKey) ?? [];
      
      for (int i = 0; i < productsJson.length; i++) {
        final product = Product.fromJson(jsonDecode(productsJson[i]));
        if (product.id == productId) {
          final updatedProduct = product.copyWith(stock: newStock);
          productsJson[i] = jsonEncode(updatedProduct.toJson());
          await prefs.setStringList(_productsKey, productsJson);
          return true;
        }
      }
      
      return false;
    } catch (e) {
      print('Error updating product stock: $e');
      return false;
    }
  }

  // Dapatkan produk berdasarkan ID
  static Future<Product?> getProductById(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = prefs.getStringList(_productsKey) ?? [];
      
      for (String productJson in productsJson) {
        final product = Product.fromJson(jsonDecode(productJson));
        if (product.id == productId) {
          return product;
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }
} 