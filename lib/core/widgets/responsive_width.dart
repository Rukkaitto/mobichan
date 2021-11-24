import 'package:flutter/material.dart';

class ResponsiveWidth extends StatelessWidget {
  final Widget child;

  const ResponsiveWidth({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return child;
        } else {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: child,
            ),
          );
        }
      },
    );
  }
}
