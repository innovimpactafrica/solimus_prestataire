import 'dart:convert';
import 'package:http/http.dart' as http;

const _kGooglePlacesApiKey = 'AIzaSyAGd7ZK7kkDEr9NOWcQOzkbDL8ddUStX9A';

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
    final uri = Uri.https('maps.googleapis.com', '/maps/api/place/autocomplete/json', {
      'input': input,
      'key': _kGooglePlacesApiKey,
      'language': 'fr',
      'types': 'geocode',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) return [];
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['status'] != 'OK') return [];
    return (data['predictions'] as List)
        .map((p) => PlacePrediction(
              placeId: p['place_id'] as String,
              description: p['description'] as String,
            ))
        .toList();
  }

  Future<PlaceCoordinates?> getCoordinates(String placeId) async {
    final uri = Uri.https('maps.googleapis.com', '/maps/api/place/details/json', {
      'place_id': placeId,
      'fields': 'geometry',
      'key': _kGooglePlacesApiKey,
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
