import 'package:flutter/material.dart';
import 'package:flutter_api/pages/auth/register_screen.dart';
import 'package:flutter_api/pages/menu_screen.dart';
import 'package:flutter_api/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.pink[300],
                child: const Icon(Icons.lock, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Welcome Text
              Text(
                "Selamat Datang",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[900],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Silakan login untuk melanjutkan",
                style: TextStyle(color: Colors.pink[700]),
              ),
              const SizedBox(height: 30),

              // Form
              Container(
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
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Button login
                    ElevatedButton.icon(
                      onPressed: () async {
                        bool success = await _authService.login(
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const MenuScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login Gagal')),
                          );
                        }
                      },
                      icon: const Icon(Icons.login),
                      label: const Text("Login"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[400],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Register button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: Text(
                  "Belum punya akun? Daftar di sini",
                  style: TextStyle(
                    color: Colors.pink[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
