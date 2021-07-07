import 'package:flutter/material.dart';

class RoundDimmedImage extends StatelessWidget {
  final ImageProvider imageProvider;

  const RoundDimmedImage(
    this.imageProvider, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
    );
  }
}
