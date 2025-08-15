import 'dart:convert';
import 'dart:io';
import 'package:flutter_api/models/order_detail_model.dart';
import 'package:flutter_api/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderServices {
  static const String baseUrl = 'http://127.0.0.1:8000/api/orders';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Ambil semua order
  static Future<List<DataOrder>> listOrders() async {
    final token = await getToken();

    if (token == null) {
      throw Exception("Token is null. Please login first.");
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final orderModel = OrderModel.fromJson(jsonMap);
      return orderModel.data ?? [];
    } else {
      throw Exception('Failed to load orders');
    }
  }


  // Buat order baru
  Future<bool> createOrder({
    required int qty,
    required int price,
    required int idProduct,
  }) async {
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

  // Ambil detail order berdasarkan kode order
  static Future<OrderDetailModel> getOrderDetail(String code) async {
  final token = await getToken();
  final response = await http.get(
    Uri.parse('$baseUrl/$code'),
    headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return OrderDetailModel.fromJson(jsonData);
  } else {
    throw Exception('Failed to load order detail');
  }
}

}
