import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nueva_mascara/services/google_places_services.dart';
import 'package:nueva_mascara/models/prediction.dart';

class AlertaInmediataScreen extends StatefulWidget {
  const AlertaInmediataScreen({super.key});

  @override
  State<AlertaInmediataScreen> createState() => _AlertaInmediataScreenState();
}

class _AlertaInmediataScreenState extends State<AlertaInmediataScreen> {
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _pacienteController = TextEditingController();
  final TextEditingController _polizaController = TextEditingController();
  final TextEditingController _especialidadController = TextEditingController();

  GoogleMapController? mapController;
  LatLng initialPosition = const LatLng(-12.0464, -77.0428);
  Marker? marker;

  bool _cargando = true;

  late GooglePlacesService googleService;

  List<Prediction> predictions = [];

  @override
  void initState() {
    super.initState();
    googleService = GooglePlacesService("AIzaSyBLZP0t_8PTNoGMTQ9uJfnUNSokN_YJEAE");
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _cargando = false);
        return;
      }
      final doc =
          await FirebaseFirestore.instance.collection('usuario').doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          _pacienteController.text = data['nombre'] ?? 'No disponible';
          _polizaController.text = data['poliza'] ?? 'No disponible';
          _especialidadController.text = data['especialidad'] ?? 'No disponible';
          _celularController.text = data['telefono'] ?? '';
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

  void buscarLugar(String input) async {
    if (input.isEmpty) {
      setState(() => predictions = []);
      return;
    }
    var result = await googleService.getAutocomplete(input);
    setState(() {
      predictions = result;
    });
  }

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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  labelText: "Dirección de paciente",
                  suffixIcon: Icon(Icons.location_on),
                ),
                onChanged: buscarLugar,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  final p = predictions[index];
                  return ListTile(
                    title: Text(p.description),
                    onTap: () async {
                      if (p.placeId.isEmpty) return;
                      var result = await googleService.getPlaceDetails(p.placeId);
                      if (result != null &&
                          result['geometry'] != null &&
                          result['geometry']['location'] != null) {
                        final loc = result['geometry']['location'];
                        final newPos = LatLng(loc['lat'], loc['lng']);

                        setState(() {
                          _direccionController.text =
                              result['formatted_address'] ?? '';
                          predictions = [];
                          marker = Marker(
                            markerId: const MarkerId('paciente'),
                            position: newPos,
                          );
                        });

                        mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No se pudo obtener la ubicación'),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialPosition,
                    zoom: 12,
                  ),
                  markers: marker != null ? {marker!} : {},
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  onTap: (LatLng pos) async {
                    setState(() {
                      marker = Marker(
                        markerId: const MarkerId('paciente'),
                        position: pos,
                      );
                      predictions = [];
                    });
                    final address =
                        await googleService.getAddressFromLatLng(pos.latitude, pos.longitude);
                    setState(() {
                      _direccionController.text = address;
                    });
                  },
                  gestureRecognizers: Set()
                    ..add(
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _confirmarCita,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F56D9),
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
            ],
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
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Este campo es obligatorio' : null,
    );
  }

  void _confirmarCita() {
    context.push('/asesoria/cita-inmediata/preguntas');
  }
}
