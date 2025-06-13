import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/product.dart';
import '../models/sale.dart';
import '../services/database_service.dart';

void main() {
  late DatabaseService dbService;

  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Set the database factory
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Initialize database service
    dbService = DatabaseService();
    
    // Delete existing database file if it exists
    final dbPath = await getDatabasesPath();
    final dbFile = File('$dbPath/pos_app.db');
    if (await dbFile.exists()) {
      // Close database first if it exists
      await dbService.close();
      await dbFile.delete();
    }
    
    // Initialize new database
    await dbService.database;
  });

  tearDown(() async {
    // Clear data but keep connection open
    final db = await dbService.database;
    await db.delete('products');
    await db.delete('sales');
  });

  tearDownAll(() async {
    // Close database only at the end of all tests
    await dbService.close();
  });

  test('Test product CRUD operations', () async {
    // Insert product
    final product = Product(
      id: '1',
      name: 'Test Product',
      price: 100.0,
      stock: 10,
      userId: 'user1',
    );

    final insertedId = await dbService.insertProduct(product.toJson());
    expect(insertedId, isPositive);

    // Get all products
    final products = await dbService.getAllProducts();
    expect(products.length, 1);

    // Update product
    final updatedProduct = product.copyWith(stock: 20);
    final updateResult = await dbService.updateProduct(insertedId, updatedProduct.toJson());
    expect(updateResult, 1);

    // Delete product
    final deleteResult = await dbService.deleteProduct(insertedId);
    expect(deleteResult, 1);
  });

  test('Test sales operations', () async {
    // Insert product first
    final product = Product(
      id: '1',
      name: 'Test Product',
      price: 100.0,
      stock: 10,
      userId: 'user1',
    );
    final productId = await dbService.insertProduct(product.toJson());

    // Insert sale
    final sale = Sale(
      id: 1,
      productId: productId,
      quantity: 2,
      totalAmount: 200.0,
      saleDate: DateTime.now(),
    );
    final saleId = await dbService.insertSale(sale.toJson());
    expect(saleId, isPositive);

    // Get sales by date
    final sales = await dbService.getSalesByDate(DateTime.now());
    expect(sales.length, 1);
  });
}
