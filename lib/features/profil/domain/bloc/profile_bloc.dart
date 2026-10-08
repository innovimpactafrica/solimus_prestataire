import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC for Profile feature following Innov & Impact Africa Guidelines.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepository(),
        super(const ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LoadSubscriptionData>(_onLoadSubscriptionData);
  }

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final data = await _repository.getProfile();
      emit(ProfileLoaded(data));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      await _repository.updatePersonalInfo(
        companyName: event.companyName,
        firstName: event.fullName,
        lastName: '',
        phone: event.phone,
        email: event.email,
        interventionZone: event.address,
        photo: event.avatarFile,
      );
      emit(const ProfileUpdatedSuccess());
      final updated = await _repository.getProfile();
      emit(ProfileLoaded(updated));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadSubscriptionData(
    LoadSubscriptionData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final data = await _repository.getSubscription();
      emit(SubscriptionLoaded(data));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
