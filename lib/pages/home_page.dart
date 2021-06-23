import 'package:flutter/material.dart';
import 'package:mobichan/widgets/drawer_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobichan"),
      ),
      drawer: MyDrawer(),
      body: Container(),
    );
  }
}
