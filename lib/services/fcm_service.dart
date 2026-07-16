import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Traitement en background — Firebase gère l'affichage automatiquement
}

class FcmService {
  static const _base = 'https://api.solimus.innovimpactdev.cloud';

  static Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Afficher les notifications en foreground sur iOS
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> registerToken() async {
    try {
      final messaging = FirebaseMessaging.instance;

      final settings = await messaging.requestPermission();
      print('[FCM] Permission: ${settings.authorizationStatus}');

      // Sur iOS, attendre que le token APNS soit disponible
      String? token;
      for (int i = 0; i < 10; i++) {
        token = await messaging.getToken();
        if (token != null) break;
        await Future.delayed(const Duration(seconds: 2));
      }
      print('[FCM] Token: $token');
      if (token == null) return;

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      if (accessToken.isEmpty) {
        print('[FCM] Pas de accessToken, abandon');
        return;
      }

      final response = await http.put(
        Uri.parse('$_base/api/notifications/fcm-token').replace(
          queryParameters: {'fcmToken': token},
        ),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      print('[FCM] Backend response: ${response.statusCode} ${response.body}');

      messaging.onTokenRefresh.listen((newToken) async {
        final p = await SharedPreferences.getInstance();
        final t = p.getString('accessToken') ?? '';
        if (t.isEmpty) return;
        await http.put(
          Uri.parse('$_base/api/notifications/fcm-token').replace(
            queryParameters: {'fcmToken': newToken},
          ),
          headers: {'Authorization': 'Bearer $t'},
        );
      });
    } catch (e) {
      print('[FCM] Erreur: $e');
    }
  }
}
