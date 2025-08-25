import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final direccionController = TextEditingController();
  final especialidadController = TextEditingController();
  final polizaController = TextEditingController();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> _register() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final direccion = direccionController.text.trim();
    final especialidad = especialidadController.text.trim();
    final poliza = polizaController.text.trim();

    if ([name, phone, email, password, direccion, especialidad, poliza].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    try {
      // Crear usuario en Firebase Authentication
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCred.user!.uid;

      // Guardar datos adicionales en Firestore
      await _db.collection('usuario').doc(uid).set({
        'nombre_completo': name,
        'celular': phone,
        'email': email,
        'direccion': direccion,
        'especialidad': especialidad,
        'poliza': poliza,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario registrado con éxito")),
      );

      context.go('/login');
    } on FirebaseAuthException catch (e) {
      String msg = 'Ocurrió un error';
      if (e.code == 'email-already-in-use') {
        msg = 'Este correo ya está registrado';
      } else if (e.code == 'weak-password') {
        msg = 'La contraseña es muy débil';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error inesperado: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nombre completo"),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Ej. José Francia Caycho"),
        ),
        const SizedBox(height: 16),

        const Text("Número de celular"),
        const SizedBox(height: 8),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: "Ej. 946564283"),
        ),
        const SizedBox(height: 16),

        const Text("Correo"),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(hintText: "Ej. jb_francia2004@yahoo.es"),
        ),
        const SizedBox(height: 16),

        const SizedBox(height: 16),

        const Text("Dirección"),
        const SizedBox(height: 8),
        TextField(
          controller: direccionController,
          decoration: const InputDecoration(hintText: "Ej. Av. Siempre Viva 123"),
        ),
        const SizedBox(height: 16),

        const Text("Especialidad"),
        const SizedBox(height: 8),
        TextField(
          controller: especialidadController,
          decoration: const InputDecoration(hintText: "Ej. Dermatología"),
        ),
        const SizedBox(height: 16),

        const Text("Póliza"),
        const SizedBox(height: 8),
        TextField(
          controller: polizaController,
          decoration: const InputDecoration(hintText: "Ej. 1234567890"),
        ),

        const SizedBox(height: 16),
        const Text("Clave"),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.visibility),
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _register,
            child: const Text("Crear cuenta"),
          ),
        ),
      ],
    );
  }
}
