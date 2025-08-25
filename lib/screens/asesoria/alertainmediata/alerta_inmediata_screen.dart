import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class AlertaInmediataScreen extends StatefulWidget {
  const AlertaInmediataScreen({super.key});

  @override
  State<AlertaInmediataScreen> createState() => _AlertaInmediataScreenState();
}

class _AlertaInmediataScreenState extends State<AlertaInmediataScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _pacienteController = TextEditingController();
  final TextEditingController _polizaController = TextEditingController();
  final TextEditingController _especialidadController = TextEditingController();

  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() => _cargando = false);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('usuario')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          _pacienteController.text = data['nombre_completo'] ?? 'No disponible';
          _polizaController.text = data['poliza'] ?? 'No disponible';
          _especialidadController.text =
              data['especialidad'] ?? 'No disponible';
          _celularController.text = data['celular'] ?? '';
          _correoController.text = data['email'] ?? '';
          _direccionController.text = data['direccion'] ?? '';
          _cargando = false;
        });
      } else {
        setState(() => _cargando = false);
      }
    } catch (e) {
      setState(() => _cargando = false);
    }
  }

  // @override
  // void dispose() {
  //   _celularController.dispose();
  //   _correoController.dispose();
  //   _direccionController.dispose();
  //   _pacienteController.dispose();
  //   _polizaController.dispose();
  //   _especialidadController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0E0D1B),
          title: const Text('Datos para Videoconsulta Inmediata'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField('Paciente', _pacienteController),
                  const SizedBox(height: 16),

                  _buildTextField('Celular de contacto', _celularController),
                  const SizedBox(height: 16),

                  _buildTextField('Póliza', _polizaController),
                  const SizedBox(height: 16),

                  _buildTextField('Especialidad', _especialidadController),
                  const SizedBox(height: 16),

                  _buildTextField('Correo de contacto', _correoController),
                  const SizedBox(height: 16),

                  _buildTextField(
                    'Dirección de paciente',
                    _direccionController,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmarCita,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F56D9), // morado
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Confirmar Cita'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF1A1A2E),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7F56D9), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    validator: (value) =>
        (value == null || value.isEmpty) ? 'Este campo es obligatorio' : null,
  );
}

  void _confirmarCita() {
    context.push('/asesoria/cita-inmediata/preguntas');
  }

}
