import 'package:flutter/material.dart';
import 'package:mobichan/views/home_page.dart';
import 'package:mobichan/views/boards_page.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobichan',
      initialRoute: '/',
      routes: {
        '/boards': (context) => BoardsPage(),
      },
      home: HomePage(),
    );
  }
}
