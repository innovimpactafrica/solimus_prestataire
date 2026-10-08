import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class NavItem extends StatefulWidget {
  final String iconPath;
  final String? activeIconPath;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const NavItem({
    super.key,
    required this.iconPath,
    this.activeIconPath,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );
  late final Animation<double> _anim =
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

  void _handleTap() {
    _ctrl.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIconPath =
        (widget.isActive && widget.activeIconPath != null)
            ? widget.activeIconPath!
            : widget.iconPath;

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, child) => Stack(
          alignment: Alignment.center,
          children: [
            if (_anim.value > 0)
              Opacity(
                opacity: (1 - _anim.value) * 0.25,
                child: Container(
                  width: 48 * _anim.value,
                  height: 48 * _anim.value,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            child!,
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
              child: Center(
                child: SvgPicture.asset(
                  effectiveIconPath,
                  height: 22,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontWeight:
                    widget.isActive ? FontWeight.w700 : FontWeight.w400,
                fontSize: 11,
                height: 1.2,
                color: widget.isActive
                    ? AppColors.white
                    : AppColors.white.withValues(alpha: 0.5),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
