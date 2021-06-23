import 'package:flutter/material.dart';
import 'package:mobichan/pages/boards_list_page.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text("Boards"),
              onTap: () =>
                  Navigator.pushNamed(context, BoardsListPage.routeName),
            )
          ],
        ),
      ),
    );
  }
}
