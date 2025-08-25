import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
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
      'Tu cita ha sido agendada para el $fecha',
      platformDetails,
    );
  }

  Future<void> _guardarCita() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes iniciar sesión o entrar como invitado')),
        );
        return;
      }

      final String fecha =
          "${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}";

      await FirebaseFirestore.instance.collection('citas').add({
        'uid': user.uid,
        'fecha': fecha,
        'fechaTimestamp': _selectedDay,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _mostrarNotificacion(fecha);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cita confirmada para el $fecha')),
      );

      context.push('/asesoria/cita-inmediata/resumen');

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la cita: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
        backgroundColor: const Color(0xFF007B9F),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF7B5BFA),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Color(0xFFB39DDB),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _selectedDay != null ? _guardarCita : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007B9F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
              ),
              child: const Text('Confirmar cita'),
            ),
          ],
        ),
      ),
    );
  }
}
