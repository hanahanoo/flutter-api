import 'package:flutter/material.dart';
import 'package:flutter_api/pages/orders/list_order_detail.dart';
import 'package:flutter_api/models/order_model.dart';
import 'package:flutter_api/services/order_service.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        title: const Text('Daftar Order'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DataOrder>>(
        future: OrderServices.listOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada order'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.white,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink[200],
                    child: const Icon(Icons.receipt_long, color: Colors.white),
                  ),
                  title: Text(
                    'Order ${order.orderCode}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[900],
                    ),
                  ),
                  subtitle: Text(
                    'Total: Rp ${order.total}',
                    style: TextStyle(color: Colors.pink[600]),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailPage(
                          code: order.orderCode ?? '',
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
