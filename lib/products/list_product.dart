import 'package:flutter/material.dart';
import 'package:flutter_api/models/product_model.dart';
import 'package:flutter_api/products/detail_product.dart';
import 'package:flutter_api/services/product_service.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key, required this.categoryId, required this.categoryName});
  final int categoryId;
  final String categoryName;

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  late Future<ProductModel> _futureProducts;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _futureProducts = ProductService.listProducts(categoryId: widget.categoryId);
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products - ${widget.categoryName}'),
      ),
      body: FutureBuilder<ProductModel>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data?.data ?? [];
          if (products.isEmpty) return const Center(child: Text('No products yet'));

          return RefreshIndicator(
            onRefresh: _refreshProducts,
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: product.foto != null && product.foto!.isNotEmpty
                        ? Image.network(
                            'http://127.0.0.1:8000/storage/${product.foto}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(product.name ?? 'No Name'),
                    subtitle: Text(product.desc ?? ''),
                    trailing: Text('\$${product.price ?? 0}'),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailProductScreen(product: product)),
                      );
                      _refreshProducts(); // Refresh list setelah kembali dari detail
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
