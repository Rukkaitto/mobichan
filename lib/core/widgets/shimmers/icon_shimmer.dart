import 'package:flutter/material.dart';

class IconShimmer extends StatelessWidget {
  final IconData icon;
  final double size;
  const IconShimmer({
    Key? key,
    required this.icon,
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.white,
      size: size,
    );
  }
}
