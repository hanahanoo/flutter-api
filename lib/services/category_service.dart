import 'dart:convert';
import 'dart:io';
import 'package:flutter_api/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/categories';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get all categories
  static Future<CategoryModel> listCategories() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return CategoryModel.fromJson(json);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Create new category
  static Future<bool> createCategory(String name) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'name': name}),
    );
    return response.statusCode == 201;
  }

  // Update category
  static Future<bool> updateCategory(int id, String name) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'name': name}),
    );
    return response.statusCode == 200;
  }

  // Delete category
  static Future<bool> deleteCategory(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}
