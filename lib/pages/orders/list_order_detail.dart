import 'package:flutter/material.dart';
import 'package:flutter_api/models/order_detail_model.dart';
import 'package:flutter_api/services/order_service.dart';

class OrderDetailPage extends StatelessWidget {
  final String code;
  const OrderDetailPage({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Detail Order $code'),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<OrderDetailModel>(
        future: OrderServices.getOrderDetail(code),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final order = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Kode Order', '${order.data?.idOrder}'),
                  const SizedBox(height: 12),
                  _buildRow('Produk', order.data?.product?.name ?? '-'),
                  const SizedBox(height: 12),
                  _buildRow('Qty', '${order.data?.qty}'),
                  const SizedBox(height: 12),
                  _buildRow('Total Harga', 'Rp ${order.data?.price}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.pink[900],
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.pink[700],
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
