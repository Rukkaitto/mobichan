import 'package:flutter/material.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';

import 'board_expansion_tile.dart';

extension BoardExpansionTileWidgetBuilders on BoardExpansionTileWidget {
  Widget buildIcon() {
    return Icon(
      icon,
      size: iconSize,
    );
  }

  Widget buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
      padding: const EdgeInsets.all(0),
      constraints: const BoxConstraints(),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.displayLarge,
    );
  }

  Widget buildSearchField(BuildContext context) {
    return TextField(
      onChanged: (input) => handleSearchFieldChanged(context, input),
      decoration: InputDecoration(
        hintText: kSearch.tr(),
        isDense: true,
      ),
    );
  }

  Widget buildSearchIcon(BuildContext context) {
    return IconButton(
      onPressed: () => handleSearchIconPressed(context),
      icon: const Icon(Icons.search),
      padding: const EdgeInsets.only(right: 5),
      constraints: const BoxConstraints(),
    );
  }
}
