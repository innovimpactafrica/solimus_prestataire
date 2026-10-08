import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class ProfilePhotoPicker extends StatelessWidget {
  final String? photoUrl;
  final String? localPhotoPath;
  final XFile? newPhoto;
  final String initials;
  final VoidCallback? onTap;

  const ProfilePhotoPicker({
    super.key,
    this.photoUrl,
    this.localPhotoPath,
    this.newPhoto,
    required this.initials,
    this.onTap,
  });

  Widget _initialsAvatar() {
    return Container(
      width: 91,
      height: 92,
      color: AppColors.border,
      child: Center(
        child: Text(
          initials.isNotEmpty ? initials : '?',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (photoUrl == null || photoUrl!.isEmpty) return _initialsAvatar();
    if (photoUrl!.startsWith('data:image')) {
      try {
        final base64Str = photoUrl!.substring(photoUrl!.indexOf(',') + 1);
        return Image.memory(
          base64Decode(base64Str),
          width: 91,
          height: 92,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _initialsAvatar(),
        );
      } catch (_) {
        return _initialsAvatar();
      }
    }
    return Image.network(
      photoUrl!,
      width: 91,
      height: 92,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _initialsAvatar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 91,
            height: 92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: newPhoto != null
                  ? Image.file(
                      File(newPhoto!.path),
                      width: 91,
                      height: 92,
                      fit: BoxFit.cover,
                    )
                  : localPhotoPath != null
                      ? Image.file(
                          File(localPhotoPath!),
                          width: 91,
                          height: 92,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _initialsAvatar(),
                        )
                      : _buildProfileImage(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
