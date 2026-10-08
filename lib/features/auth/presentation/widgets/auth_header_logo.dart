import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthHeaderLogo extends StatelessWidget {
  final double top;
  final double right;
  final double width;
  final double height;

  const AuthHeaderLogo({
    super.key,
    this.top = 62,
    this.right = 16,
    this.width = 95,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      width: width,
      height: height,
      child: SvgPicture.asset(
        'assets/images/solimus logo2.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}
