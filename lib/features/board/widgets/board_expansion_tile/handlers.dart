import 'package:flutter/material.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'board_expansion_tile.dart';

extension BoardExpansionTileWidgetHandlers on BoardExpansionTileWidget {
  void handleSearchFieldChanged(BuildContext context, String input) {
    context.read<SearchCubit>().updateInput(input);
  }

  void handleSearchIconPressed(BuildContext context) {
    context.read<SearchCubit>().startSearching(context);
  }
}
