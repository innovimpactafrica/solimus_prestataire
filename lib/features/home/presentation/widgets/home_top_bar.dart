import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/auth/data/services/user_session.dart';

class HomeTopBar extends StatelessWidget {
  final String companyName;
  final String? photoUrl;
  final VoidCallback? onNotificationTap;

  const HomeTopBar({
    super.key,
    required this.companyName,
    this.photoUrl,
    this.onNotificationTap,
  });

  Widget _initialsWidget(String initials) {
    return Container(
      width: 25,
      height: 25,
      color: AppColors.primary,
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initials = companyName.trim().isNotEmpty
        ? companyName
            .trim()
            .split(' ')
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join()
        : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour',
                style: GoogleFonts.jost(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 22 / 14,
                  letterSpacing: -0.28,
                  color: AppColors.white,
                ),
              ),
              Text(
                companyName.isNotEmpty ? companyName : 'Prestataire',
                style: GoogleFonts.jost(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 24 / 16,
                  letterSpacing: -0.31,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onNotificationTap,
                child: SvgPicture.asset(
                  'assets/icons/notification.svg',
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(width: 8),
              ValueListenableBuilder<String?>(
                valueListenable: UserSession.instance.localPhotoPath,
                builder: (_, localPath, _) {
                  Widget avatar;
                  if (localPath != null) {
                    avatar = Image.file(
                      File(localPath),
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _initialsWidget(initials),
                    );
                  } else if (photoUrl != null && photoUrl!.isNotEmpty) {
                    if (photoUrl!.startsWith('data:image')) {
                      try {
                        final bytes = base64Decode(
                            photoUrl!.substring(photoUrl!.indexOf(',') + 1));
                        avatar = Image.memory(
                          bytes,
                          width: 25,
                          height: 25,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _initialsWidget(initials),
                        );
                      } catch (_) {
                        avatar = _initialsWidget(initials);
                      }
                    } else {
                      avatar = Image.network(
                        photoUrl!,
                        width: 25,
                        height: 25,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _initialsWidget(initials),
                      );
                    }
                  } else {
                    avatar = _initialsWidget(initials);
                  }

                  return Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 1),
                    ),
                    child: ClipOval(child: avatar),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
