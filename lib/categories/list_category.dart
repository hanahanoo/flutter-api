import 'package:flutter/material.dart';
import 'package:flutter_api/models/category_model.dart';
import 'package:flutter_api/products/list_product.dart';
import 'package:flutter_api/services/category_service.dart';

class ListCategoryScreen extends StatefulWidget {
  const ListCategoryScreen({super.key});

  @override
  State<ListCategoryScreen> createState() => _ListCategoryScreenState();
}

class _ListCategoryScreenState extends State<ListCategoryScreen> {
  late Future<CategoryModel> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = CategoryService.listCategories();
  }

  void _refreshCategories() {
    setState(() {
      _futureCategories = CategoryService.listCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Pilih Kategori'),
        actions: [
          IconButton(
            onPressed: _refreshCategories,
            icon: const Icon(Icons.refresh),
            color: Colors.white,
          ),
        ],
      ),
      body: FutureBuilder<CategoryModel>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data?.data ?? [];
          if (categories.isEmpty) {
            return const Center(child: Text('Tidak ada kategori.'));
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3 / 2,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListProductScreen(
                          categoryId: category.id!,
                          categoryName: category.name ?? '',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          category.name ?? 'No Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.pink[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
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
