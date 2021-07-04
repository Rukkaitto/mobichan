import 'package:flutter/material.dart';
import 'package:mobichan/pages/boards_list_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text("Boards"),
                  onTap: () =>
                      Navigator.pushNamed(context, BoardsListPage.routeName),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (BuildContext context,
                    AsyncSnapshot<PackageInfo> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'v${snapshot.data!.version}+${snapshot.data!.buildNumber}',
                      style: Theme.of(context).textTheme.caption,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
