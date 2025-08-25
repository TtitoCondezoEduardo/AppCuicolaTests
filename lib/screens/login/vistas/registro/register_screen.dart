import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nueva_mascara/widgets/registerForm/register_form.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: const [
            SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: _BackButton(),
            ),
            SizedBox(height: 20),
            Text(
              'Crea una Cuenta',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            RegisterForm(),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {

  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        context.push('/login');
      },
    );
  }

}