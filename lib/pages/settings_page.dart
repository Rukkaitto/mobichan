import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobichan/classes/models/setting.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = SETTINGS_ROUTE;

  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String appBarTitle = 'Settings';

  void onChanged(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: FutureBuilder(
        future: rootBundle.loadString('assets/settings.json'),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            List<Setting> settings = (jsonDecode(snapshot.data!) as List)
                .map((e) => Setting.fromJson(e))
                .toList();

            return FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: settings.length,
                    itemBuilder: (context, index) {
                      Setting setting = settings[index];
                      SharedPreferences prefs = snapshot.data!;
                      Widget trailing;

                      switch (setting.type) {
                        case "toggle":
                          trailing = Switch(
                            onChanged: (bool value) {
                              setState(() {
                                onChanged(setting.key, value.toString());
                              });
                            },
                            value: prefs.containsKey(setting.key)
                                ? prefs.getString(setting.key)!.parseBool()
                                : setting.value.parseBool(),
                          );
                          break;
                        default:
                          trailing = Container();
                          break;
                      }

                      return ListTile(
                        title: Text(setting.label).tr(),
                        trailing: trailing,
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
