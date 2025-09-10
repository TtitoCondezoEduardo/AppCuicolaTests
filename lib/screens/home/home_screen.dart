import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Future<void> _enviarSMS() async {
  //   const String accountSid = 'ACc425f16dd8aa6bb7d430f083eb019892';
  //   const String authToken = '714d2e64c3759d32051a56711120adee';
  //   const String numeroTwilio = '+18316660451';
  //   const String numeroDestino = '+51902374853';
  //   const String mensaje = 'Hola! Tu cita ha sido confirmada. Esta es una prueba desde Doctor AppAcuicola.';

  //   final String url = 'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json';

  //   try {
  //     // Debug: verificar credenciales
  //     debugPrint('Account SID: $accountSid');
  //     debugPrint('Auth Token length: ${authToken.length}');
      
  //     final String credentials = base64Encode(utf8.encode('$accountSid:$authToken'));
  //     debugPrint('Credentials encoded: ${credentials.substring(0, 20)}...'); // Solo primeros 20 caracteres por seguridad
      
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': 'Basic $credentials',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //       body: {
  //         'From': numeroTwilio,
  //         'To': numeroDestino,
  //         'Body': mensaje,
  //       },
  //     );

  //     debugPrint('Status code: ${response.statusCode}');
  //     debugPrint('Response body: ${response.body}');

  //     if (response.statusCode == 201) {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('SMS enviado exitosamente'),
  //             backgroundColor: Colors.green,
  //           ),
  //         );
  //       }
  //       debugPrint('SMS enviado exitosamente');
  //     } else {
  //       debugPrint('Error al enviar SMS: ${response.statusCode}');
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Error al enviar SMS: ${response.statusCode}'),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('Excepción al enviar SMS: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error: $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

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

                // Tienda
                _HomeOption(
                  icon: Icons.store,
                  label: "Tienda",
                  onTap: () {
                    final Uri url = Uri.parse('https://acuivetsac.com/shop');
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),
                const SizedBox(height: 16),

                // // SMS - Prueba
                // _HomeOption(
                //   icon: Icons.sms,
                //   label: "Enviar SMS de prueba",
                //   onTap: _enviarSMS,
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