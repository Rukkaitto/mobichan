import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
part 'tabs_state.dart';

class TabsCubit extends Cubit<TabsState> {
  final BoardRepository repository;
  late Board current;
  late List<Board> boards;

  TabsCubit({required this.repository}) : super(TabsInitial());

  Future<void> getInitialTabs() async {
    final tabs = await repository.getFavoriteBoards();
    final lastVisitedBoard = await repository.getLastVisitedBoard();
    boards = _addTab(tabs, lastVisitedBoard);
    current = lastVisitedBoard;
    emit(TabsLoaded(boards: boards, current: current));
  }

  void addTab(Board board) {
    boards = _addTab(boards, board);
    emit(TabsLoaded(boards: boards, current: current));
  }

  void removeTab(Board board) {
    Board newCurrent;
    if (board == boards.last) {
      newCurrent = boards[boards.indexOf(board) - 1];
    } else {
      newCurrent = boards[boards.indexOf(board) + 1];
    }
    boards = _removeTab(boards, board);
    emit(TabsLoaded(boards: boards, current: newCurrent));
  }

  Future<void> setCurrentTab(Board board) async {
    await repository.saveLastVisitedBoard(board);
    boards = _addTab(boards, board);
    current = board;
    emit(TabsLoaded(boards: boards, current: current));
  }

  List<Board> _addTab(List<Board> tabs, Board tab) {
    List<Board> newTabs = List.from(tabs);
    if (!tabs.contains(tab)) {
      newTabs.add(tab);
    }

    return newTabs;
  }

  List<Board> _removeTab(List<Board> boards, Board board) {
    List<Board> newTabs = List.from(boards);
    newTabs.remove(board);
    return newTabs;
  }
}
