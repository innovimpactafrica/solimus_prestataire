import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class NavItem extends StatefulWidget {
  final String iconPath;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const NavItem({
    super.key,
    required this.iconPath,
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
                opacity: (1 - _anim.value) * 0.35,
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
          children: [
            SvgPicture.asset(widget.iconPath, width: 24, height: 24),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontWeight:
                    widget.isActive ? FontWeight.w700 : FontWeight.w500,
                fontSize: 10,
                height: 1.2,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
