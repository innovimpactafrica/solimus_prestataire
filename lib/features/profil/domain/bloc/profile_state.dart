import 'package:solimus_prestataire/features/profil/data/models/profile_models.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProviderProfile data;
  const ProfileLoaded(this.data);
}

class ProfileUpdatedSuccess extends ProfileState {
  final String message;
  const ProfileUpdatedSuccess([this.message = 'Profil mis à jour avec succès']);
}

class SubscriptionLoaded extends ProfileState {
  final SubscriptionInfo data;
  const SubscriptionLoaded(this.data);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}
