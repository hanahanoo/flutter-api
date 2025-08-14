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
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            onPressed: _refreshCategories,
            icon: const Icon(Icons.refresh),
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
            return const Center(child: Text('No categories found'));
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                child: ListTile(
                  title: Text(category.name ?? 'No Name'),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
