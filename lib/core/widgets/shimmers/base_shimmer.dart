import 'package:flutter/material.dart';

class BaseShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final bool rounded;

  const BaseShimmer({
    Key? key,
    required this.width,
    required this.height,
    this.rounded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: rounded ? BorderRadius.circular(100) : null,
        color: Colors.white,
      ),
    );
  }
}
