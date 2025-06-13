import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<void> _ensureOpen() async {
    if (_database == null) {
      _database = await _initDatabase();
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pos_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        stock INTEGER NOT NULL,
        userId TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        total_amount REAL NOT NULL,
        sale_date INTEGER NOT NULL, -- Store as Unix timestamp
        FOREIGN KEY (product_id) REFERENCES products(id)
      )
    ''');
  }

  // Products CRUD operations
  Future<int> insertProduct(Map<String, dynamic> product) async {
    await _ensureOpen();
    return await _database!.insert('products', product);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    await _ensureOpen();
    return await _database!.query('products');
  }

  Future<int> updateProduct(int id, Map<String, dynamic> product) async {
    await _ensureOpen();
    return await _database!.update('products', product, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteProduct(int id) async {
    await _ensureOpen();
    return await _database!.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // Sales operations
  Future<int> insertSale(Map<String, dynamic> sale) async {
    await _ensureOpen();
    // Convert DateTime to Unix timestamp before storing
    final saleData = Map<String, dynamic>.from(sale);
    saleData['sale_date'] = sale['sale_date'].millisecondsSinceEpoch;
    return await _database!.insert('sales', saleData);
  }

  Future<List<Map<String, dynamic>>> getSalesByDate(DateTime date) async {
    await _ensureOpen();
    // Convert DateTime to Unix timestamp (milliseconds since epoch)
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    final results = await _database!.query(
      'sales',
      where: 'sale_date >= ? AND sale_date <= ?',
      whereArgs: [
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch,
      ],
    );

    // Convert timestamps back to DateTime objects in results
    return results.map((map) {
      final newMap = Map<String, dynamic>.from(map);
      // Cast to int since we know it's stored as a timestamp
      newMap['sale_date'] = DateTime.fromMillisecondsSinceEpoch(map['sale_date'] as int);
      return newMap;
    }).toList();
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
