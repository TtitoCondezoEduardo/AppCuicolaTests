import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo.png',
              height: 160,
            ),

            const SizedBox(height: 32),

            // Título estilizado
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: "Doctor", style: TextStyle(color: Colors.white)),
                  TextSpan(text: "Appcuicola", style: TextStyle(color: Color(0xFF7B5BFA))),
                ],
              ),
            ),

            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text(
                  "Iniciemos",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
