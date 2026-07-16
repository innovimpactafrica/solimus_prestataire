import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionResponse {
  final bool success;
  final String message;
  final String transactionReference;
  final double amount;
  final String paymentUrl;

  const SubscriptionResponse({
    required this.success,
    required this.message,
    required this.transactionReference,
    required this.amount,
    required this.paymentUrl,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      SubscriptionResponse(
        success: json['success'] as bool? ?? false,
        message: json['message'] as String? ?? '',
        transactionReference: json['transactionReference'] as String? ?? '',
        amount: (json['amount'] as num? ?? 0).toDouble(),
        paymentUrl: json['paymentUrl'] as String? ?? '',
      );
}

class SubscriptionService {
  static const _base = 'https://api.solimus.innovimpactdev.cloud';

  Future<SubscriptionResponse> initiate({
    required String method,
    required bool annual,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    final response = await http.post(
      Uri.parse('$_base/api/provider/subscription/initiate'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'method': method, 'annual': annual}),
    );
    if (response.statusCode == 200) {
      return SubscriptionResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    throw Exception(body['message'] as String? ?? 'Erreur paiement');
  }
}
