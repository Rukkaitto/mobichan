import 'package:flutter/material.dart';

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
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              ListTile(
                title: Text("Boards"),
                onTap: () => Navigator.pushNamed(context, '/boards'),
              )
            ],
          ),
        ),
      ),
      body: Container(),
    );
  }
}
