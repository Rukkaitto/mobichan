import 'package:flutter/material.dart';

class ThreadRoundDimmedImage extends StatelessWidget {
  final ImageProvider imageProvider;

  const ThreadRoundDimmedImage(
    this.imageProvider, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
