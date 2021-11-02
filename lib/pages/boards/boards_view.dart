// ignore_for_file: implementation_imports

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/boards/board_tile/board_tile_view.dart';
import 'package:mobichan/pages/boards/boards_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BoardsView extends StatelessWidget {
  const BoardsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BoardsViewModel>.reactive(
      viewModelBuilder: () => BoardsViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: viewModel.isSearching
              ? TextField(
                  controller: viewModel.searchController,
                  onChanged: viewModel.changeFilter,
                  decoration: InputDecoration(
                    hintText: search.tr(),
                  ),
                  autofocus: true,
                )
              : Text(boards).tr(),
          leading: viewModel.isSearching ? BackButton() : null,
          actions: [
            IconButton(
              onPressed: () => viewModel.startSearching(context),
              icon: Icon(Icons.search_rounded),
            ),
          ],
        ),
        body: viewModel.hasError
            ? Text(viewModel.modelError)
            : viewModel.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: viewModel.list.length,
                    itemBuilder: (context, index) {
                      Board board = viewModel.list[index];
                      return BoardTileView(board: board);
                    },
                  ),
      ),
    );
  }
}
