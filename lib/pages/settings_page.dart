import 'package:flutter/material.dart';
import 'package:mobichan/constants.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = SETTINGS_ROUTE;
  final String appBarTitle = 'Settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Center(
        child: Text(
          'Coming soon',
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }
}
