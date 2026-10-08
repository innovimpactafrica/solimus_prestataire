/// Base URLs and Endpoints definitions according to Innov & Impact Africa Guidelines.
/// No hardcoded URL or endpoint allowed anywhere in the codebase.
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

  /// Google Places & Maps API
  static const String googleMapsHost = 'maps.googleapis.com';
  static const String googlePlacesAutocomplete = '/maps/api/place/autocomplete/json';
  static const String googlePlacesDetails = '/maps/api/place/details/json';

  // ==========================================
  // Auth Endpoints
  // ==========================================
  static const String authRegister = '$api/api/auth/register';
  static const String authLogin = '$api/api/auth/login';
  static const String authVerifyCode = '$api/api/auth/verify-code';
  static const String authSetPassword = '$api/api/auth/set-password';
  static const String authResetPassword = '$api/api/auth/reset-password';
  static const String authForgotPassword = '$api/api/auth/forgot-password';
  static const String authVerifyResetCode = '$api/api/auth/verify-reset-code';
  static const String authResendActivationLink = '$api/api/auth/resend-activation-link';
  static const String authLogout = '$api/api/auth/logout';

  // ==========================================
  // Dashboard Endpoints
  // ==========================================
  static const String dashboard = '$api/api/provider/accueil/dashboard';

  // ==========================================
  // Notifications / FCM
  // ==========================================
  static const String fcmToken = '$api/api/notifications/fcm-token';

  // ==========================================
  // Subscription Endpoints
  // ==========================================
  static const String subscriptionInitiate = '$api/api/provider/subscription/initiate';
  static const String subscriptionPremium = '$api/api/provider/profil/subscription/premium';
  static const String subscriptionInfo = '$api/api/provider/profile/subscription';
  static const String subscriptionCancel = '$api/api/provider/profil/subscription/cancel';

  // ==========================================
  // Profile Endpoints
  // ==========================================
  static const String profile = '$api/api/provider/profile';
  static const String profileLocation = '$api/api/provider/profile/location';
  static const String profilePersonalInfo = '$api/api/provider/profile/personal-info';
  static const String updatePersonalInfo = '$api/api/provider/profil/personal-info';
  static const String profileNotifications = '$api/api/provider/profile/notifications';
  static const String toggleAvailability = '$api/api/provider/profil/toggle-availability';

  // ==========================================
  // Wallet Endpoints
  // ==========================================
  static const String wallet = '$api/api/provider/wallet';
  static const String walletWithdraw = '$api/api/provider/wallet/withdraw';

  // ==========================================
  // Demandes & Interventions Endpoints
  // ==========================================
  static const String providerRequests = '$api/api/provider/requests';
  static String providerRequestById(int id) => '$api/api/provider/requests/$id';
  static String startDemandeRequest(int id) => '$api/api/provider/demandes/requests/$id/start';
  static String finishDemandeRequest(int id) => '$api/api/provider/demandes/requests/$id/finish';
  static String demandeComments(int id) => '$api/api/provider/demandes/requests/$id/comments';
  static String demandeWorkPhotos(int id) => '$api/api/provider/demandes/requests/$id/work-photos';
  static const String requestsCount = '$api/api/provider/demandes/requests/count';
  static const String myInterventions = '$api/api/provider/demandes/my-interventions';

  // ==========================================
  // Quotes / Devis Endpoints
  // ==========================================
  static const String quotes = '$api/api/provider/profile/quotes';
  static String quoteById(int id) => '$api/api/provider/profile/quotes/$id';
  static const String createQuote = '$api/api/provider/requests/quote';
  static String quoteAction(int id) => '$api/api/provider/requests/quote/$id';
  static const String quoteEstimatedDelays = '$api/api/provider/requests/quote/estimated-delays';

  // ==========================================
  // Travaux Endpoints
  // ==========================================
  static const String travaux = '$api/api/provider/travaux';
  static String travauxById(int id) => '$api/api/provider/travaux/$id';
  static String startTravail(int id) => '$api/api/provider/travaux/$id/start';
  static String finishTravail(int id) => '$api/api/provider/travaux/$id/finish';

  /// Helper to build full file URL
  static String fileUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$fileStorage/api/files/$cleanPath';
  }
}
