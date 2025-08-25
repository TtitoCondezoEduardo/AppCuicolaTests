import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResumenScreen extends StatefulWidget {
  const ResumenScreen({super.key});

  @override
  State<ResumenScreen> createState() => _ResumenScreenState();
  
}

class _ResumenScreenState extends State<ResumenScreen> {

  String? _fechaUltimaCita;
  bool _aceptaTerminos = false;
  String? _nombreArchivo;
  File? _archivoSeleccionado;

  Future<void> _seleccionarArchivo() async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
    );

    if (resultado != null && resultado.files.isNotEmpty) {
      setState(() {
        _archivoSeleccionado = File(resultado.files.single.path!);
        _nombreArchivo = resultado.files.single.name;
      });
    }
  }

  Future<void> _subirArchivoAFirebase() async {

    if (_archivoSeleccionado == null) return;
    
    try {
      // Extraer nombre y extensión
      final nombreOriginal = _nombreArchivo!.split('.').first;
      final extension = _nombreArchivo!.split('.').last;

      // Crear fecha formateada
      final fecha = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());

      // Nombre único
      final nombreUnico = '${nombreOriginal}_$fecha.$extension';

      // Referencia en Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('constancias_pago')
          .child(nombreUnico);

      // Subida
      await ref.putFile(_archivoSeleccionado!);

      // Obtener URL de descarga
      final url = await ref.getDownloadURL();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Archivo subido con éxito: $nombreUnico')),
      );

      debugPrint('URL de descarga: $url');
    } catch (e) {
      debugPrint('Error completo al subir archivo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir archivo: $e')),
      );
    }
  }

  Future<void> _obtenerUltimaCita() async {
  final user = FirebaseAuth.instance.currentUser;

   if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('citas')
        .where('uid', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      setState(() {
        _fechaUltimaCita = data['fecha'];
      });
    }

  }

  @override
  void initState() {
    super.initState();
    _obtenerUltimaCita();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0D1B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0D1B),
        foregroundColor: Colors.white,
        title: const Text('Resumen de Cita'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Costos del servicio',
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Fecha de la cita: $_fechaUltimaCita',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Cita virtual inmediata: S/ 120.00',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Instrucciones',
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            const SizedBox(height: 8),
            const Text(
              'Transferir y subir constancia\nBBVA XXXXXXXX - USD',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 24),
            const Text(
              'Resumen de pago',
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            const SizedBox(height: 8),
            const Text(
              'Total a pagar: S/120.00',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _aceptaTerminos,
                  onChanged: (value) =>
                      setState(() => _aceptaTerminos = value ?? false),
                ),
                const Expanded(
                  child: Text(
                    'Acepto los términos y condiciones y política de privacidad',
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Subir archivo constancia de pago',
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _seleccionarArchivo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F56D9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.upload_file, size: 20),
                  label: const Text(
                    'Subir archivo',
                    style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _nombreArchivo ?? 'Ningún archivo seleccionado',
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_aceptaTerminos && _archivoSeleccionado != null)
                    ? _subirArchivoAFirebase
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
