import 'package:flutter/material.dart';
import 'package:flutter_api/models/product_model.dart';
import 'package:flutter_api/products/detail_product.dart';
import 'package:flutter_api/services/product_service.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

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
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        title: Text('Produk - ${widget.categoryName}'),
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
          if (products.isEmpty) {
            return const Center(child: Text('Tidak ada produk'));
          }

          return RefreshIndicator(
            onRefresh: _refreshProducts,
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = products[index];

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailProductScreen(product: product),
                      ),
                    );
                    _refreshProducts();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(16)),
                          child: product.foto != null && product.foto!.isNotEmpty
                              ? Image.network(
                                  'http://127.0.0.1:8000/storage/${product.foto}',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 40),
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.pink[100],
                                  child: const Icon(Icons.image_not_supported,
                                      size: 40),
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name ?? 'Tanpa Nama',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.pink[800],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  product.desc ?? '',
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rp ${product.price ?? 0}',
                                  style: TextStyle(
                                    color: Colors.pink[700],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
