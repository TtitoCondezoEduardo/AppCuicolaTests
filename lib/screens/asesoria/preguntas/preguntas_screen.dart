import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PreguntasScreen extends StatelessWidget {
  const PreguntasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0D1B), // fondo oscuro
      appBar: AppBar(
        title: const Text('Cuestionario de Salud'),
        backgroundColor: const Color(0xFF0E0D1B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Por favor complete todas las preguntas para un mejor diagnóstico',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),

              _buildQuestion(
                numero: 1,
                pregunta: '¿Qué ha observado en sus peces?',
                hint: 'Ejm: Heridas en los costados, diarrea amarilla...',
              ),
              const SizedBox(height: 16),

              _buildQuestion(
                numero: 2,
                pregunta: '¿Cantidad de peces sembrados?',
                hint: 'Ejm: 3 millares, 5000',
              ),
              const SizedBox(height: 16),

              _buildQuestion(
                numero: 3,
                pregunta: '¿Hace cuánto comenzó la mortalidad?',
                hint: 'Ejm: Hace 2 días',
              ),
              const SizedBox(height: 16),

              _buildQuestion(
                numero: 4,
                pregunta: '¿Les ha aplicado algún tratamiento?',
                hint: 'Describa los tratamientos utilizados',
              ),
              const SizedBox(height: 16),

              _buildQuestion(
                numero: 5,
                pregunta: '¿Ha ocurrido un cambio en los parámetros de agua?',
                hint: 'Ejm: 3 veces al dia',
              ),
              const SizedBox(height: 32),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/citas');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Programar Cita'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion({
    required int numero,
    required String pregunta,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$numero. $pregunta',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF0E0D1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
