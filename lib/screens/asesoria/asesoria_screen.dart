import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AsesoriaScreen extends StatelessWidget {
  const AsesoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige una modalidad para tu cita'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Un especialista te atenderá en cualquiera de ellas.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // Opción 1
          _CitaCard(
            icon: Icons.videocam,
            title: 'Cita Virtual inmediata',
            subtitle:
                'Accede a una videoconsulta de lunes a domingo.\n> Medicina general: de 7:00 a.m. a 9:00 p.m.\n> Pediatría: de 9:00 a.m. a 9:00 p.m.',
            badgeText: 'Ahora',
            color: const Color(0xFF1E2A38),
            onTap: () => context.push('/asesoria/cita-inmediata'),
          ),
          const SizedBox(height: 16),

          // Opción 2
          _CitaCard(
            icon: Icons.schedule,
            title: 'Cita Virtual programada',
            subtitle:
                'Realiza las videoconsultas que necesites desde tu casa y atiéndete con los mejores especialistas.',
            color: const Color(0xFF2C2A32),
            onTap: () {
              final Uri url = Uri.parse('https://www.zoom.com/es');
              launchUrl(url, mode: LaunchMode.externalApplication);
            },
          ),
          const SizedBox(height: 16),

          // Opción 3
          _CitaCard(
            icon: Icons.location_city,
            title: 'Cita Presencial',
            subtitle:
                'Acércate a un centro médico ACUIVET y atiéndete con nuestros mejores especialistas.',
            color: const Color(0xFF1E2A38),
            onTap: () {},
          ),

          const SizedBox(height: 32),

          // Botón regresar
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Regresar'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CitaCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;
  final String? badgeText;

  const _CitaCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(icon, color: Colors.black87),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(subtitle),
                    if (badgeText != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badgeText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
