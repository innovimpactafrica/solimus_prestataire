import 'dart:developer' as dev;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/demandes_models.dart';
import '../models/devis_models.dart';
import '../models/wallet_models.dart';
import '../models/profile_models.dart';

class DemandesService {
  static const _base = 'https://api.solimus.innovimpactdev.cloud';

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<AvailableRequestsPage> getAvailableRequests({
    String? search,
    String? status,
    int page = 0,
    int size = 50,
  }) async {
    final params = <String, String>{
      'page': '$page',
      'size': '$size',
      if (search != null && search.isNotEmpty) 'search': search,
      if (status != null && status.isNotEmpty) 'status': status,
    };
    final uri = Uri.parse('$_base/api/provider/demandes/available-requests')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: await _authHeaders());
    if (response.statusCode == 200) {
      return AvailableRequestsPage.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Erreur chargement demandes (${response.statusCode})');
  }

  Future<DemandeRequest> getRequestById(int id) async {
    final response = await http.get(
      Uri.parse('$_base/api/provider/demandes/requests/$id'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return DemandeRequest.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Erreur chargement demande (${response.statusCode})');
  }

  Future<void> startRequest(int id) async {
    final response = await http.post(
      Uri.parse('$_base/api/provider/demandes/requests/$id/start'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur démarrage intervention (${response.statusCode})');
    }
  }

  Future<void> finishRequest(int id) async {
    final response = await http.post(
      Uri.parse('$_base/api/provider/demandes/requests/$id/finish'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur finalisation intervention (${response.statusCode})');
    }
  }

  Future<void> addComment(int id, String commentaire) async {
    final uri = Uri.parse('$_base/api/provider/demandes/requests/$id/comments')
        .replace(queryParameters: {'commentaire': commentaire});
    final response = await http.post(uri, headers: await _authHeaders());
    if (response.statusCode != 200) {
      throw Exception('Erreur ajout commentaire (${response.statusCode})');
    }
  }

  Future<DevisDetail> getQuoteById(int id) async {
    final response = await http.get(
      Uri.parse('$_base/api/provider/demandes/quotes/$id'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return DevisDetail.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Erreur chargement devis (${response.statusCode}): ${response.body}');
  }

  Future<DevisDetail> getQuoteByReference(String reference) async {
    final response = await http.get(
      Uri.parse('$_base/api/provider/demandes/quotes/$reference'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return DevisDetail.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Erreur chargement devis (${response.statusCode}): ${response.body}');
  }

  Future<DevisListResponse> getQuotes({
    String? statut,
    String? search,
    int page = 0,
    int size = 50,
  }) async {
    final params = <String, String>{
      'page': '$page',
      'size': '$size',
      if (statut != null && statut.isNotEmpty) 'statut': statut,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final uri = Uri.parse('$_base/api/provider/demandes/quotes').replace(queryParameters: params);
    final response = await http.get(uri, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      dev.log('QUOTES RESPONSE: $decoded');
      return DevisListResponse.fromJson(decoded);
    }
    throw Exception('Erreur chargement devis (${response.statusCode}): ${response.body}');
  }

  Future<List<Map<String, dynamic>>> getEstimatedDelays() async {
    final endpoints = [
      '$_base/api/provider/demandes/estimated-delays',
    ];
    for (final url in endpoints) {
      try {
        final response = await http.get(Uri.parse(url), headers: await _authHeaders());
        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          List<dynamic> list;
          if (body is List) {
            list = body;
          } else if (body is Map && body.containsKey('content')) {
            list = body['content'] as List;
          } else if (body is Map && body.containsKey('data')) {
            list = body['data'] as List;
          } else {
            continue;
          }
          return list
              .map((e) => e as Map<String, dynamic>)
              .where((e) => e.containsKey('id'))
              .toList();
        }
      } catch (_) {}
    }
    return [];
  }

  Future<void> createQuote({
    required int interventionRequestId,
    required int estimatedDelayId,
    String? additionalComments,
    required List<Map<String, dynamic>> items,
    required bool draft,
  }) async {
    final body = <String, dynamic>{
      'interventionRequestId': interventionRequestId,
      'estimatedDelayId': estimatedDelayId,
      'items': items,
      'draft': draft,
      if (additionalComments != null && additionalComments.isNotEmpty)
        'additionalComments': additionalComments,
    };
    final response = await http.post(
      Uri.parse('$_base/api/provider/demandes/quotes'),
      headers: await _authHeaders(),
      body: jsonEncode(body),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur création devis (${response.statusCode}): ${response.body}');
    }
  }

  Future<String?> updatePersonalInfo({
    required String companyName,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String interventionZone,
    double? latitude,
    double? longitude,
    XFile? photo,
  }) async {
    final headers = await _authHeaders();
    headers.remove('Content-Type');

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('$_base/api/provider/profil/personal-info'),
    );
    request.headers.addAll(headers);

    if (companyName.isNotEmpty) request.fields['companyName'] = companyName;
    if (firstName.isNotEmpty) request.fields['firstName'] = firstName;
    if (lastName.isNotEmpty) request.fields['lastName'] = lastName;
    if (phone.isNotEmpty) request.fields['phone'] = phone;
    if (email.isNotEmpty) request.fields['email'] = email;
    if (interventionZone.isNotEmpty) request.fields['interventionZone'] = interventionZone;
    if (latitude != null) request.fields['latitude'] = '$latitude';
    if (longitude != null) request.fields['longitude'] = '$longitude';

    if (photo != null) {
      final bytes = await photo.readAsBytes();
      final ext = photo.path.split('.').last.toLowerCase();
      final mimeSubtype = ext == 'png' ? 'png' : ext == 'gif' ? 'gif' : 'jpeg';
      final filename = photo.name.isNotEmpty ? photo.name : 'profile.$ext';
      request.files.add(http.MultipartFile.fromBytes(
        'photo',
        bytes,
        filename: filename,
        contentType: MediaType('image', mimeSubtype),
      ));
    }

    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();
    final status = streamed.statusCode;
    if (status != 200 && status != 201 && status != 204) {
      throw Exception('Erreur mise à jour profil ($status): $body');
    }

    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final url = json['profilePhotoUrl'] as String? ??
          json['photoUrl'] as String? ??
          json['avatar'] as String?;
      return (url != null && url.isNotEmpty) ? url : null;
    } catch (_) {
      return null;
    }
  }

  Future<PaymentInitResponse> subscribeToPremium({
    required String moyenPaiement,
    required bool renouvellementAuto,
  }) async {
    const successUrl = 'https://api.solimus.innovimpactdev.cloud/payment-success.html';
    const failedUrl  = 'https://api.solimus.innovimpactdev.cloud/payment-failed.html';
    final body = {
      'moyenPaiement': moyenPaiement,
      'renouvellementAuto': renouvellementAuto,
      'successUrl': successUrl,
      'failedUrl': failedUrl,
      'successRedirectUrl': successUrl,
      'failedRedirectUrl': failedUrl,
      'redirectSuccessUrl': successUrl,
      'redirectFailedUrl': failedUrl,
    };
    final response = await http.post(
      Uri.parse('$_base/api/provider/profil/subscription/premium'),
      headers: await _authHeaders(),
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return PaymentInitResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    String detail = response.body;
    try {
      final j = jsonDecode(response.body) as Map<String, dynamic>;
      detail = j['message'] as String? ?? j['error'] as String? ?? j['detail'] as String? ?? response.body;
    } catch (_) {}
    throw Exception('Erreur souscription (${response.statusCode}) : $detail');
  }

  Future<SubscriptionInfo> getSubscription() async {
    final response = await http.get(
      Uri.parse('$_base/api/provider/profil/subscription'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return SubscriptionInfo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Erreur chargement abonnement (${response.statusCode})');
  }

  Future<ProviderProfile> getProfile() async {
    final response = await http.get(
      Uri.parse('$_base/api/provider/profil'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return ProviderProfile.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Erreur chargement profil (${response.statusCode})');
  }

  Future<ProfileInfo> getPersonalInfo() async {
    final response = await http.get(
      Uri.parse('$_base/api/provider/profil/personal-info'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return ProfileInfo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Erreur chargement profil (${response.statusCode})');
  }

  Future<void> cancelSubscription() async {
    final response = await http.post(
      Uri.parse('$_base/api/provider/profil/subscription/cancel'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur annulation abonnement (${response.statusCode})');
    }
  }

  Future<void> toggleNotifications() async {
    final response = await http.post(
      Uri.parse('$_base/api/provider/profil/notifications/toggle'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur toggle notifications (${response.statusCode})');
    }
  }

  Future<void> toggleAvailability() async {
    final response = await http.post(
      Uri.parse('$_base/api/provider/profil/toggle-availability'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur toggle disponibilité (${response.statusCode})');
    }
  }

  Future<void> withdraw({
    required int montant,
    required String methode,
    required String numeroDeTelephone,
  }) async {
    final body = {
      'montant': montant,
      'methode': methode,
      'numeroDeTelephone': numeroDeTelephone,
    };
    final response = await http.post(
      Uri.parse('$_base/api/provider/wallet/withdraw'),
      headers: await _authHeaders(),
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur demande de versement (${response.statusCode})');
    }
  }

  Future<WalletData> getWallet() async {
    final response = await http.get(
      Uri.parse('$_base/api/provider/wallet'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return WalletData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Erreur chargement wallet (${response.statusCode})');
  }

  Future<void> uploadWorkPhoto(int id, XFile photo) async {
    final headers = await _authHeaders();
    headers.remove('Content-Type');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_base/api/provider/demandes/requests/$id/work-photos'),
    );
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    final streamed = await request.send();
    if (streamed.statusCode != 200) {
      throw Exception('Erreur upload photo (${streamed.statusCode})');
    }
  }
}

class AvailableRequestsPage {
  final int totalElements;
  final int totalPages;
  final int totalRequests;
  final List<DemandeRequestSummary> content;

  const AvailableRequestsPage({
    required this.totalElements,
    required this.totalPages,
    required this.totalRequests,
    required this.content,
  });

  factory AvailableRequestsPage.fromJson(Map<String, dynamic> json) {
    final requests = (json['requests'] as Map<String, dynamic>?) ?? json;
    return AvailableRequestsPage(
      totalRequests: (json['totalRequests'] as num?)?.toInt() ?? 0,
      totalElements: (requests['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (requests['totalPages'] as num?)?.toInt() ?? 0,
      content: (requests['content'] as List? ?? [])
          .map((e) => DemandeRequestSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
