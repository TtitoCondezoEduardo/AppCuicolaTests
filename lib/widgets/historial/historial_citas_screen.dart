import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistorialCitasScreen extends StatelessWidget {
  const HistorialCitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Debes iniciar sesión para ver tu historial.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Citas'),
        backgroundColor: const Color(0xFF007B9F),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF0E0D1B),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('citas')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No tienes citas registradas',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final citas = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              final fechaTexto = cita['fecha'] ?? 'Fecha desconocida';
              final fechaTimestamp = cita['fechaTimestamp']?.toDate();
              final ahora = DateTime.now();

              final bool esVencida = fechaTimestamp != null && fechaTimestamp.isBefore(ahora);

              return Card(
                color: esVencida ? Colors.red.shade100 : Colors.green.shade100,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_month,
                    color: esVencida ? Colors.red : Colors.green,
                  ),
                  title: Text(
                    esVencida ? 'Cita Vencida' : 'Cita Programada',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: esVencida ? Colors.red.shade700 : Colors.green.shade700,
                    ),
                  ),
                  subtitle: Text(
                    'Fecha: $fechaTexto',
                    style: TextStyle(
                      decoration: esVencida ? TextDecoration.lineThrough : null,
                      color: Colors.black87,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
