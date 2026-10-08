import 'package:image_picker/image_picker.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'package:solimus_prestataire/features/profil/data/models/profile_models.dart';
import '../services/subscription_service.dart';

/// Repository for Profile feature following Innov & Impact Africa Guidelines.
class ProfileRepository {
  final DemandesService _demandesService;
  final SubscriptionService _subscriptionService;

  ProfileRepository({
    DemandesService? demandesService,
    SubscriptionService? subscriptionService,
  })  : _demandesService = demandesService ?? DemandesService(),
        _subscriptionService = subscriptionService ?? SubscriptionService();

  Future<ProviderProfile> getProfile() => _demandesService.getProfile();

  Future<ProfileInfo> getPersonalInfo() => _demandesService.getPersonalInfo();

  Future<void> updateProfile({
    required String companyName,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String profilePhotoUrl,
    required String specialtyName,
    required String interventionZone,
  }) =>
      _demandesService.updateProfile(
        companyName: companyName,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        profilePhotoUrl: profilePhotoUrl,
        specialtyName: specialtyName,
        interventionZone: interventionZone,
      );

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
  }) =>
      _demandesService.updatePersonalInfo(
        companyName: companyName,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        interventionZone: interventionZone,
        latitude: latitude,
        longitude: longitude,
        photo: photo,
      );

  Future<SubscriptionInfo> getSubscription({int page = 0, int size = 10}) =>
      _demandesService.getSubscription(page: page, size: size);

  Future<SubscriptionResponse> initiateSubscription({
    required String method,
    required bool annual,
  }) =>
      _subscriptionService.initiate(method: method, annual: annual);

  Future<void> toggleAvailability() => _demandesService.toggleAvailability();

  Future<void> toggleNotifications() => _demandesService.toggleNotifications();

  Future<void> cancelSubscription() => _demandesService.cancelSubscription();
}
