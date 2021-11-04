import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/boards/view/boards_view.dart';
import 'package:mobichan/pages/history_page.dart';
import 'package:mobichan/pages/settings_page.dart';
import 'package:mobichan/widgets/drawer/cubit/favorites_cubit/favorites_cubit.dart';
import 'package:mobichan/widgets/drawer/cubit/package_info_cubit/package_info_cubit.dart';
import 'package:mobichan/widgets/drawer/view/drawer_favorites.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocProvider<FavoritesCubit>(
        create: (context) => FavoritesCubit()..getFavorites(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildNavigation(context),
              Flexible(
                child: DrawerFavorites(),
              ),
              buildPackageInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Column buildNavigation(BuildContext context) {
    return Column(
      children: [
        Builder(
          builder: (context) {
            return ListTile(
              leading: Icon(Icons.list_rounded),
              title: Text(boards).tr(),
              onTap: () {
                Navigator.pushNamed(context, BoardsView.routeName).then((_) {
                  context.read<FavoritesCubit>().getFavorites();
                });
              },
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.history_rounded),
          title: Text(history).tr(),
          onTap: () => Navigator.pushNamed(context, HistoryPage.routeName),
        ),
        ListTile(
          leading: Icon(Icons.settings_rounded),
          title: Text(settings).tr(),
          onTap: () => Navigator.pushNamed(context, SettingsPage.routeName),
        ),
      ],
    );
  }

  Padding buildPackageInfo() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocProvider<PackageInfoCubit>(
        create: (context) => PackageInfoCubit()..getPackageInfo(),
        child: BlocBuilder<PackageInfoCubit, PackageInfoState>(
          builder: (context, state) {
            if (state is PackageInfoLoaded) {
              return Text(
                  'v${state.packageInfo.version}+${state.packageInfo.buildNumber}');
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
