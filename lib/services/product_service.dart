import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_api/models/product_model.dart';

class ProductService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/products';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<ProductModel> listProducts({int? categoryId}) async {
    final token = await getToken();
    final uri = Uri.parse(categoryId != null ? '$baseUrl?category_id=$categoryId' : baseUrl);
    final response = await http.get(
      uri,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ProductModel.fromJson(json);
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<DataProduct> showProduct(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DataProduct.fromJson(data['data']);
    } else {
      throw Exception('Failed to load product');
    }
  }

  static Future<bool> createProduct(
      String name,
      String description,
      int price,
      int categoryId,
      Uint8List? imageBytes,
      String? imageName,
  ) async {
    final token = await getToken();
    final request = http.MultipartRequest('POST', Uri.parse(baseUrl));

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['category_id'] = categoryId.toString();

    if (imageBytes != null && imageName != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    request.headers['Authorization'] = 'Bearer $token';
    final response = await request.send();
    return response.statusCode == 201;
  }

  static Future<bool> updateProduct(
      int id,
      String name,
      String description,
      int price,
      int categoryId,
      Uint8List? imageBytes,
      String? imageName,
  ) async {
    final token = await getToken();
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/$id?_method=PUT'));

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['category_id'] = categoryId.toString();

    if (imageBytes != null && imageName != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    request.headers['Authorization'] = 'Bearer $token';
    final response = await request.send();
    return response.statusCode == 200;
  }

  static Future<bool> deleteProduct(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}
