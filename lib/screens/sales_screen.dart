import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../services/transaction_service.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/transaction.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Product> _products = [];
  List<TransactionItem> _cartItems = [];
  bool _isLoading = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await AuthService.getCurrentUser();
    if (user != null) {
      final products = await ProductService.getProducts(user.username);
      setState(() {
        _currentUser = user;
        _products = products;
        _isLoading = false;
      });
    }
  }

  void _addToCart(Product product) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex >= 0) {
      setState(() {
        _cartItems[existingIndex] = TransactionItem(
          productId: product.id,
          productName: product.name,
          price: product.price,
          quantity: _cartItems[existingIndex].quantity + 1,
          subtotal: product.price * (_cartItems[existingIndex].quantity + 1),
        );
      });
    } else {
      setState(() {
        _cartItems.add(TransactionItem(
          productId: product.id,
          productName: product.name,
          price: product.price,
          quantity: 1,
          subtotal: product.price,
        ));
      });
    }
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      setState(() {
        _cartItems.removeAt(index);
      });
    } else {
      setState(() {
        _cartItems[index] = TransactionItem(
          productId: _cartItems[index].productId,
          productName: _cartItems[index].productName,
          price: _cartItems[index].price,
          quantity: newQuantity,
          subtotal: _cartItems[index].price * newQuantity,
        );
      });
    }
  }

  double get _totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  Future<void> _processTransaction() async {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Cek stok
    for (TransactionItem item in _cartItems) {
      final product = _products.firstWhere((p) => p.id == item.productId);
      if (product.stock < item.quantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stok ${product.name} tidak mencukupi!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final success = await TransactionService.createTransaction(
      _cartItems,
      _currentUser!.username,
    );

    if (success) {
      setState(() {
        _cartItems.clear();
      });
      await _loadData(); // Reload products untuk update stok
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaksi berhasil! Total: Rp ${_totalPrice.toStringAsFixed(0)}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memproses transaksi!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Baru'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Daftar Produk
                Expanded(
                  flex: 2,
                  child: _products.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Belum ada produk',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tambahkan produk terlebih dahulu',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return Card(
                              child: InkWell(
                                onTap: () => _addToCart(product),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Rp ${product.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Stok: ${product.stock}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                
                // Keranjang
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Keranjang',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Total: Rp ${_totalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _cartItems.isEmpty
                            ? const Center(
                                child: Text(
                                  'Keranjang kosong',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                itemCount: _cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = _cartItems[index];
                                  return Card(
                                    child: ListTile(
                                      title: Text(item.productName),
                                      subtitle: Text('Rp ${item.price.toStringAsFixed(0)}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () => _updateQuantity(index, item.quantity - 1),
                                          ),
                                          Text('${item.quantity}'),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () => _updateQuantity(index, item.quantity + 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      if (_cartItems.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _processTransaction,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Proses Transaksi',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
} 