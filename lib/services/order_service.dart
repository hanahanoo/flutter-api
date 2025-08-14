import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_api/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderServices {
  static const String baseUrl = 'http://127.0.0.1:8000/api/orders';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<OrderModel> listOrders() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return OrderModel.fromJson(json);
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<bool> createOrder({required int qty, price, idProduct}) async {
    final token = await getToken();
    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri);
    request.fields['qty'] = qty.toString();
    request.fields['price'] = price.toString();
    request.fields['id_product'] = idProduct.toString();

    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();
    return response.statusCode == 201;
  }

  // static Future<OrderDetailModel> showPost(String code) async {
  //   final token = await getToken();
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/$code'),
  //     headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return OrderDetailModel.fromJson(data['data']);
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

  // Get all posts
  // static Future<CategoryModel> listCategories() async {
  //   final token = await getToken();
  //   final response = await http.get(
  //     Uri.parse(baseUrl),
  //     headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
  //   );
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     return CategoryModel.fromJson(json);
  //   } else {
  //     throw Exception('Failed to load categories');
  //   }
  // }

  // Get single post by ID
  // static Future<DataProduct> showPost(int id) async {
  //   final token = await getToken();
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/$id'),
  //     headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return DataProduct.fromJson(data['data']);
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

  // Create new post
  // static Future<bool> createPost(
  //   String title,
  //   String content,
  //   int status,
  //   Uint8List? imageBytes,
  //   String? imageName,
  // ) async {
  //   final token = await getToken();
  //   final uri = Uri.parse(baseUrl);
  //   final request = http.MultipartRequest('POST', uri);

  //   request.fields['title'] = title;
  //   request.fields['content'] = content;
  //   request.fields['status'] = status.toString();

  //   if (imageBytes != null && imageName != null) {
  //     request.files.add(
  //       http.MultipartFile.fromBytes(
  //         'foto',
  //         imageBytes,
  //         filename: imageName,
  //         contentType: MediaType('image', 'jpeg'),
  //       ),
  //     );
  //   }

  //   request.headers['Authorization'] = 'Bearer $token';

  //   final response = await request.send();
  //   return response.statusCode == 201;
  // }

  // Update existing post
  // static Future<bool> updatePost(
  //   int id,
  //   String title,
  //   String content,
  //   int status,
  //   Uint8List? imageBytes,
  //   String? imageName,
  // ) async {
  //   final token = await getToken();
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('$baseUrl/$id?_method=PUT'),
  //   );

  //   request.fields['title'] = title;
  //   request.fields['content'] = content;
  //   request.fields['status'] = status.toString();

  //   if (imageBytes != null && imageName != null) {
  //     request.files.add(
  //       http.MultipartFile.fromBytes(
  //         'foto',
  //         imageBytes,
  //         filename: imageName,
  //         contentType: MediaType('image', 'jpeg'),
  //       ),
  //     );
  //   }

  //   request.headers['Authorization'] = 'Bearer $token';

  //   final response = await request.send();
  //   return response.statusCode == 200;
  // }

  // Delete post
  // static Future<bool> deletePost(int id) async {
  //   final token = await getToken();
  //   final response = await http.delete(
  //     Uri.parse('$baseUrl/$id'),
  //     headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
  //   );
  //   return response.statusCode == 200;
  // }
}