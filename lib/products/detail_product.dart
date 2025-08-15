import 'package:flutter/material.dart';
import 'package:flutter_api/models/product_model.dart';
import 'package:flutter_api/pages/menu_screen.dart';
import 'package:flutter_api/pages/orders/list.dart';
import 'package:flutter_api/services/order_service.dart';

class DetailProductScreen extends StatelessWidget {
  final DataProduct product;
  final OrderServices _orderService = OrderServices();

  DetailProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        title: Text(product.name ?? 'Detail Produk'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.foto != null && product.foto!.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'http://127.0.0.1:8000/storage/${product.foto!}',
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              )
            else
              const Center(
                child: Icon(Icons.shopping_bag, size: 100),
              ),
            const SizedBox(height: 20),

            // Nama produk
            Text(
              product.name ?? '',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.pink[800],
              ),
            ),
            const SizedBox(height: 8),

            // Harga
            Text(
              'Rp ${product.price ?? 0}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.pink[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Stok
            Text(
              'Stok: ${product.stock ?? 0}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),

            // Deskripsi
            Text(
              'Deskripsi Produk',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.pink[700],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.desc ?? '-',
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 30),

            // Tombol Order
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Pesan Sekarang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => _showOrderDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDialog(BuildContext context) {
    final qtyController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pesan Produk'),
        content: TextField(
          controller: qtyController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Jumlah',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Pesan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final qty = int.tryParse(qtyController.text) ?? 0;
              if (qty <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Masukkan quantity yang valid'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              bool success = await _orderService.createOrder(
                qty: qty,
                price: product.price!,
                idProduct: product.id!,
              );

              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pesanan berhasil dibuat'),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => OrderPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pesanan gagal dibuat'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
