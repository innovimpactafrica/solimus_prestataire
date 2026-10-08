/// Global application constants according to Innov & Impact Africa Guidelines.
class AppConstants {
  AppConstants._();

  // App Metadata
  static const String appName = 'Solimus Prestataire';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String tokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String userDataKey = 'userData';

  // API & Third Party Keys
  static const String googlePlacesApiKey =
      'AIzaSyAGd7ZK7kkDEr9NOWcQOzkbDL8ddUStX9A';

  // Pagination defaults
  static const int defaultPageSize = 10;
  static const int defaultInitialPage = 0;

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
