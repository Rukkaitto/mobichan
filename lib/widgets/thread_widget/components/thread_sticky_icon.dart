import 'package:flutter/material.dart';

class ThreadStickyIcon extends StatelessWidget {
  const ThreadStickyIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Icon(
        Icons.push_pin_rounded,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
