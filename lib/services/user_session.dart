import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  UserSession._();
  static final instance = UserSession._();

  static const _prefKey = 'profile_local_photo_path';

  final localPhotoPath = ValueNotifier<String?>(null);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved != null && File(saved).existsSync()) {
      localPhotoPath.value = saved;
    }
  }

  Future<String> saveLocalPhoto(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final dest = '${dir.path}/profile_photo.jpg';
    await File(sourcePath).copy(dest);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, dest);
    localPhotoPath.value = dest;
    return dest;
  }
}
