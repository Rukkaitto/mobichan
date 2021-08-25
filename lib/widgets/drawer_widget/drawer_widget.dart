import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/boards_list_page.dart';
import 'package:mobichan/pages/history_page.dart';
import 'package:mobichan/pages/settings_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'components/drawer_favorites.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  ScrollController _scrollController = ScrollController();

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
                  leading: Icon(Icons.list_rounded),
                  title: Text(boards).tr(),
                  onTap: () =>
                      Navigator.pushNamed(context, BoardsListPage.routeName)
                          .then((_) => setState(() {})),
                ),
                ListTile(
                  leading: Icon(Icons.history_rounded),
                  title: Text(history).tr(),
                  onTap: () =>
                      Navigator.pushNamed(context, HistoryPage.routeName),
                ),
                ListTile(
                  leading: Icon(Icons.settings_rounded),
                  title: Text(settings).tr(),
                  onTap: () =>
                      Navigator.pushNamed(context, SettingsPage.routeName),
                ),
              ],
            ),
            DrawerFavorites(scrollController: _scrollController),
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
