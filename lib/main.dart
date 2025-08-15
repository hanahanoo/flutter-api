import 'package:flutter/material.dart';
import 'package:flutter_api/categories/list_category.dart';
import 'package:flutter_api/pages/auth/login_screen.dart';
import 'package:flutter_api/pages/menu_screen.dart'; // import halaman categories
import 'package:flutter_api/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belajar Flutter',
      // Nanti kita pakai widget AuthCheck di home
      home: const AuthCheck(),
      // Tambahkan routes supaya bisa navigation ke halaman lain
      routes: {
        '/menu': (context) => const MenuScreen(),
        '/categories': (context) => const ListCategoryScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final AuthService _authService = AuthService();
  late Future<bool> _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = _authService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return const MenuScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
