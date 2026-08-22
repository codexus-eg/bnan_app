import 'package:flutter/material.dart';

class MasterCardLogo extends StatelessWidget {
  const MasterCardLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 53,
      height: 30,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: _LogoCircle(color: Color(0xffFF4B3E)),
          ),
          Positioned(
            right: 0,
            child: _LogoCircle(color: Color(0xffFFD045)),
          ),
        ],
      ),
    );
  }
}

class _LogoCircle extends StatelessWidget {
  const _LogoCircle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 33.85,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
