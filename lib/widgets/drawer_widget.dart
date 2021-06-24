import 'package:flutter/material.dart';
import 'package:mobichan/pages/boards_list_page.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.list),
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