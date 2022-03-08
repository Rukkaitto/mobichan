import 'package:flutter/material.dart';
import 'package:mobichan/core/core.dart';

class TextShimmer extends StatelessWidget {
  final double? width;

  const TextShimmer({
    this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      width: width,
      height: 10,
    );
  }
}
