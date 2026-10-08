/// Base URLs definitions according to Innov & Impact Africa Guidelines.
/// No hardcoded URL allowed anywhere in the codebase.
class BaseUrl {
  BaseUrl._();

  /// Main API base URL
  static const String api = 'https://api.solimus.sn';

  /// File storage base URL (documents, attachments)
  static const String fileStorage = 'https://api.coopachat.innovimpactdev.cloud';

  /// Payment callback URLs
  static const String paymentSuccessCallback =
      'https://api.solimus.innovimpactdev.cloud/payment-success.html';
  static const String paymentFailedCallback =
      'https://api.solimus.innovimpactdev.cloud/payment-failed.html';

  /// Google Places & Maps API host
  static const String googleMapsHost = 'maps.googleapis.com';

  /// Helper to build full file URL
  static String fileUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$fileStorage/api/files/$cleanPath';
  }
}
