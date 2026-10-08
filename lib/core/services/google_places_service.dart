import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/base_url.dart';
import '../utils/app_constants.dart';

class PlacePrediction {
  final String placeId;
  final String description;
  const PlacePrediction({required this.placeId, required this.description});
}

class PlaceCoordinates {
  final double lat;
  final double lng;
  const PlaceCoordinates({required this.lat, required this.lng});
}

class GooglePlacesService {
  Future<List<PlacePrediction>> autocomplete(String input) async {
    if (input.trim().length < 2) return [];
    final uri = Uri.https(BaseUrl.googleMapsHost, BaseUrl.googlePlacesAutocomplete, {
      'input': input,
      'key': AppConstants.googlePlacesApiKey,
      'language': 'fr',
      'types': 'geocode',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) return [];
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['status'] != 'OK') return [];
    return (data['predictions'] as List)
        .where((p) => p['place_id'] != null && p['description'] != null)
        .map((p) => PlacePrediction(
              placeId: p['place_id'] as String,
              description: p['description'] as String,
            ))
        .toList();
  }

  Future<PlaceCoordinates?> getCoordinates(String placeId) async {
    final uri = Uri.https(BaseUrl.googleMapsHost, BaseUrl.googlePlacesDetails, {
      'place_id': placeId,
      'fields': 'geometry',
      'key': AppConstants.googlePlacesApiKey,
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) return null;
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['status'] != 'OK') return null;
    final location = data['result']['geometry']['location'];
    return PlaceCoordinates(
      lat: (location['lat'] as num).toDouble(),
      lng: (location['lng'] as num).toDouble(),
    );
  }
}
