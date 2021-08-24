import 'package:flutter/material.dart';
import 'package:mobichan/widgets/drawer_widget/drawer_widget.dart';

class NsfwWarningPage extends StatelessWidget {
  final Function() onDismiss;
  const NsfwWarningPage({Key? key, required this.onDismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NSFW Warning'),
      ),
      drawer: DrawerWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This board contains Not Safe For Work content.'),
            ElevatedButton(onPressed: onDismiss, child: Text('Enter anyway')),
          ],
        ),
      ),
    );
  }
}
