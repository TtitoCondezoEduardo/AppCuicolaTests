import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Asegúrate de tener esta importación

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final uid = FirebaseAuth.instance.currentUser?.uid;
      final token = await FirebaseMessaging.instance.getToken();

      if (uid != null && token != null) {
        await FirebaseFirestore.instance.collection('usuario').doc(uid).update({
          'token': token,
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login exitoso")),
      );

      context.go('/home');
    } on FirebaseAuthException catch (e) {
      String msg = 'Ocurrió un error';
      if (e.code == 'user-not-found') {
        msg = 'Usuario no encontrado';
      } else if (e.code == 'wrong-password') {
        msg = 'Contraseña incorrecta';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Correo"),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "tsmith@email.com",
          ),
        ),
        const SizedBox(height: 16),
        const Text("Clave"),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.visibility_off, color: Colors.white70),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _login,
            child: const Text("Ingresa"),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            "No recuerdo mi clave",
            style: TextStyle(color: Colors.white60),
          ),
        ),
        const SizedBox(height: 32),
        const Divider(color: Colors.white24),
        const SizedBox(height: 16),
        const Center(
          child: Text("¿Aún no tienes una cuenta?"),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => context.push('/register'),
            child: const Text("Crear cuenta"),
          ),
        ),
      ],
    );
  }
}
