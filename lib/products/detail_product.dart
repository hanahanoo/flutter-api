import 'package:flutter/material.dart';
import 'package:flutter_api/models/product_model.dart';
import 'package:flutter_api/pages/menu_screen.dart';
import 'package:flutter_api/services/order_service.dart';

class DetailProductScreen extends StatelessWidget {
  final DataProduct product;
  final OrderServices _orderService = OrderServices();

  DetailProductScreen({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? 'Product Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.foto != null && product.foto!.isNotEmpty)
              Center(
                child: Image.network(
                  'http://127.0.0.1:8000/storage/${product.foto!}',
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              )
            else
              const Center(
                child: Icon(Icons.shopping_bag, size: 100),
              ),
            const SizedBox(height: 16),
            Text(
              product.name ?? '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${product.price ?? 0}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stock: ${product.stock ?? 0}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.desc ?? '-',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Order Now'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  _showOrderDialog(context);
                },
              ),
            )
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
        title: const Text('Order Product'),
        content: TextField(
          controller: qtyController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantity',
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Order'),
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
                price: product.price,
                idProduct: product.id!,
              );

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pesanan berhasil dibuat'),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => MenuScreen()),
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
            // onPressed: () {
            //   final qty = int.tryParse(qtyController.text) ?? 0;
            //   if (qty > 0) {
            //     Navigator.pop(context);
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content:
            //             Text('Order placed: ${product.name} x$qty'),
            //       ),
            //     );
            //   }
            // },
          ),
        ],
      ),
    );
  }
}
