import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/pages/boards/board_tile/board_tile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BoardTileView extends StatelessWidget {
  final Board board;
  const BoardTileView({Key? key, required this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BoardTileViewModel>.reactive(
      viewModelBuilder: () => BoardTileViewModel(board),
      builder: (context, viewModel, child) => ListTile(
        title: Text('/${board.board}/ - ${board.title}'),
        trailing: IconButton(
          onPressed: () => viewModel.onPressedFavorite(board),
          icon: Icon(
            viewModel.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_outline_rounded,
          ),
        ),
        onTap: () => viewModel.goToBoard(context, board),
      ),
    );
  }
}
