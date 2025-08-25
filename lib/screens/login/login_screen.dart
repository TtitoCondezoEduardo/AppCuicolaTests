import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nueva_mascara/widgets/loginForm/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          const SizedBox(height: 40),

          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.go('/');
              },
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Ingresa acuícola",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 24),
          const LoginForm(),
        ],
      ),
    ),
  );
  }
}