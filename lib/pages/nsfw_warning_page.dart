import 'package:flutter/material.dart';

class NsfwWarningPage extends StatelessWidget {
  final Function() onDismiss;
  const NsfwWarningPage({Key? key, required this.onDismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This board is marked as NSFW.'),
            ElevatedButton(onPressed: onDismiss, child: Text('Enter')),
          ],
        ),
      ),
    );
  }
}
