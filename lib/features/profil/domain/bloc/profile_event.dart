import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfileData extends ProfileEvent {
  const LoadProfileData();
}

class UpdateProfileEvent extends ProfileEvent {
  final String fullName;
  final String companyName;
  final String email;
  final String phone;
  final String address;
  final String description;
  final XFile? avatarFile;

  const UpdateProfileEvent({
    required this.fullName,
    required this.companyName,
    required this.email,
    required this.phone,
    required this.address,
    required this.description,
    this.avatarFile,
  });
}

class LoadSubscriptionData extends ProfileEvent {
  const LoadSubscriptionData();
}
