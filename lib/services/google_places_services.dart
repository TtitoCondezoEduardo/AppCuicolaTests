import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nueva_mascara/models/prediction.dart';

class GooglePlacesService {
  final String apiKey;
  GooglePlacesService(this.apiKey);

  Future<List<Prediction>> getAutocomplete(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&language=es&components=country:pe';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final predictions = data['predictions'] as List;
      return predictions.map((e) => Prediction.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener predicciones');
    }
  }

  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&language=es';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'];
    } else {
      throw Exception('Error al obtener detalles del lugar');
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey&language=es';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0]['formatted_address'];
      }
      return "Dirección no encontrada";
    } else {
     throw Exception('Error HTTP al obtener predicciones: ${response.statusCode}');
    }
  }
}
