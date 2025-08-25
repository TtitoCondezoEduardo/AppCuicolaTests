import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título + ícono
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: "Doctor", style: TextStyle(color: Color(0xFF014D63))),
                          TextSpan(text: " AppAcuícola", style: TextStyle(color: Color(0xFF247B9F))),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/logo.png',
                      height: 150,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Asesoría veterinaria
                _HomeOption(
                  icon: Icons.pets,
                  label: "Asesoría veterinaria",
                  onTap: () => context.push('/asesoria'),
                ),
                const SizedBox(height: 16),

                // Formación acuícola
                _HomeOption(
                  icon: Icons.school,
                  label: "Formación acuícola",
                  onTap: () {
                    final Uri url = Uri.parse('https://acuivetsac.com/slides');
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),
                const SizedBox(height: 16),

                // NUEVO: Tienda
                _HomeOption(
                  icon: Icons.store,
                  label: "Tienda",
                  onTap: () {
                    final Uri url = Uri.parse('https://acuivetsac.com/shop'); // ← Cambia la URL aquí
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),
                const SizedBox(height: 16),

                
                // // Historial
                // _HomeOption(
                //   icon: Icons.history,
                //   label: "Historial",
                //   onTap: () => context.push('/historial-citas'),
                // ),
                // const SizedBox(height: 16),
                

                const SizedBox(height: 24),

                // Logo ACUIVET más pequeño
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: Color(0xFF007B9F), size: 36),
                const SizedBox(width: 20),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF014D63),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
