import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _especialistaSeleccionado;
  List<String> _especialistas = [];
  bool _cargandoEspecialistas = true;
  TimeOfDay? _horaSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarEspecialistas();
  }

  Future<void> _cargarEspecialistas() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('especialistas')
          .get();

      final especialistas = snapshot.docs
          .map((doc) => doc.data()['nombre_especialista'] as String)
          .toList();

      setState(() {
        _especialistas = especialistas;
        _cargandoEspecialistas = false;
      });
    } catch (e) {
      setState(() {
        _cargandoEspecialistas = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar especialistas: $e')),
        );
      }
    }
  }

  Future<void> _seleccionarHora() async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (hora != null) {
      setState(() {
        _horaSeleccionada = hora;
      });
    }
  }

  String _formatearHora(TimeOfDay hora) {
    final horaStr = hora.hour.toString().padLeft(2, '0');
    final minutoStr = hora.minute.toString().padLeft(2, '0');
    return '$horaStr:$minutoStr';
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

      if (_especialistaSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes seleccionar un especialista')),
        );
        return;
      }

      if (_horaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes seleccionar una hora')),
        );
        return;
      }

      final String fecha =
          "${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}";
      
      final String hora = _formatearHora(_horaSeleccionada!);

      await FirebaseFirestore.instance.collection('citas').add({
        'uid': user.uid,
        'fecha': fecha,
        'hora': hora,
        'fechaTimestamp': _selectedDay,
        'especialista': _especialistaSeleccionado,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            
            const Text(
              'Seleccionar especialista',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            
            _cargandoEspecialistas
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _especialistaSeleccionado,
                        hint: const Text('Selecciona un especialista'),
                        isExpanded: true,
                        items: _especialistas.map((String especialista) {
                          return DropdownMenuItem<String>(
                            value: especialista,
                            child: Text(especialista),
                          );
                        }).toList(),
                        onChanged: (String? nuevoValor) {
                          setState(() {
                            _especialistaSeleccionado = nuevoValor;
                          });
                        },
                      ),
                    ),
                  ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Seleccionar hora',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            
            GestureDetector(
              onTap: _seleccionarHora,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(
                      _horaSeleccionada != null 
                          ? _formatearHora(_horaSeleccionada!)
                          : 'Selecciona una hora',
                      style: TextStyle(
                        fontSize: 16,
                        color: _horaSeleccionada != null 
                            ? Colors.white 
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: (_selectedDay != null && 
                           _especialistaSeleccionado != null && 
                           _horaSeleccionada != null) 
                    ? _guardarCita 
                    : null,
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
            ),
          ],
        ),
      ),
    );
  }
}