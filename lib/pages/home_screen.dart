import 'package:flutter/material.dart';
import 'package:flutter_api/categories/list_category.dart';
import 'package:flutter_api/products/list_product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo kantin (pakai icon makanan)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.4),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(24),
                child: Icon(
                  Icons.restaurant_menu,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 32),

              // Judul selamat datang
              Text(
                'Selamat Datang di Kantin',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[800],
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),

              // Deskripsi kecil
              Text(
                'Nikmati berbagai pilihan produk terbaik kami!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.pink[600],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
