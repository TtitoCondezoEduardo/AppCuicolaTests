import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class ResumenScreen extends StatefulWidget {
  const ResumenScreen({super.key});

  @override
  State<ResumenScreen> createState() => _ResumenScreenState();
  
}

class _ResumenScreenState extends State<ResumenScreen> {

  String? _fechaUltimaCita;
  String? _horaUltimaCita;
  bool _aceptaTerminos = false;
  String? _nombreArchivo;
  File? _archivoSeleccionado;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _obtenerUltimaCita();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(initSettings);

    // Solicitar permisos de notificaciones en Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _mostrarNotificacion(String fecha) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'citas_channel',
      'Recordatorios de Citas',
      channelDescription: 'Canal para notificar citas locales',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      0,
      'Cita confirmada',
      'Tu cita ha sido confirmada para el $fecha',
      platformDetails,
    );
  }

  // Future<void> _enviarWhatsApp() async {
  //   const String accessToken = 'EAA7Byo9BoRIBPfJneKSGlv5f18PDexumXiFlrAtwZCAoRU6ZAj8Kol2IEE5d9WRjq5a2CF3oXSGTZBtPwIDoxFAUqMe2fsDqbzxbUsTP5C4JBAPTEMYRDZBoFw42nOiZBeSvQaOWLBnFmwWkUZC8VavTkgIvM3VEaczZBf6kIBZBn446lTYzpKNrFXGQzJXKR9XhKuXnu0QE7urepuSR83tZBiNShdB06HtbHEXX3VsJqZCWBycXMZD';
  //   const String phoneNumberId = '796399373553261';
  //   const String numeroDestino = '51902374853';
    
  //   final String mensaje = 'Hola! Tu cita ha sido confirmada para el $_fechaUltimaCita a las $_horaUltimaCita. Doctor AppAcuicola. Este es el link de tu Zoom: https://www.zoom.com/';
    
  //   debugPrint('Enviando WhatsApp a: $numeroDestino');
  //   debugPrint('Mensaje: $mensaje');
    
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://graph.facebook.com/v22.0/$phoneNumberId/messages'),
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'messaging_product': 'whatsapp',
  //         'to': numeroDestino,
  //         'type': 'text',
  //         'text': {
  //           'body': mensaje,
  //         },
  //       }),
  //     );

  //     debugPrint('Status code: ${response.statusCode}');
  //     debugPrint('Response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       debugPrint('WhatsApp enviado exitosamente');
  //     } else {
  //       debugPrint('Error al enviar WhatsApp: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('Excepción al enviar WhatsApp: $e');
  //   }
  // }

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
        _horaUltimaCita = data['hora'];
      });
    }
  }

  void _continuar() async {
    if (_aceptaTerminos && _archivoSeleccionado != null) {
      // Mostrar notificación de cita confirmada
      if (_fechaUltimaCita != null) {
        await _mostrarNotificacion(_fechaUltimaCita!);
      }
      
      // Enviar WhatsApp de confirmación
      // await _enviarWhatsApp();
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cita confirmada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navegar al home del proyecto
      context.go('/home');
    }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fecha de la cita: $_fechaUltimaCita',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hora de la cita: $_horaUltimaCita',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
                    ? _continuar
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