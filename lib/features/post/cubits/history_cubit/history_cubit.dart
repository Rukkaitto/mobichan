import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final PostRepository repository;
  late List<Post> history;

  HistoryCubit({required this.repository}) : super(HistoryInitial());

  Future<void> addToHistory(Post thread, Board board) async {
    history = await repository.addThreadToHistory(thread, board);
    emit(HistoryLoaded(history));
  }

  Future<void> getHistory() async {
    emit(HistoryLoading());
    history = await repository.getHistory();
    emit(HistoryLoaded(history));
  }

  void search(String input) {
    if (input == "") {
      emit(HistoryLoaded(history));
    } else {
      final filteredHistory = history
          .where((post) =>
              (post.board?.board.contains(input.toLowerCase().trim()) ??
                  false) ||
              (post.board?.title
                      .toLowerCase()
                      .contains(input.toLowerCase().trim()) ??
                  false) ||
              (post.sub?.toLowerCase().contains(input.toLowerCase().trim()) ??
                  false) ||
              (post.com?.toLowerCase().contains(input.toLowerCase().trim()) ??
                  false))
          .toList();
      emit(HistoryLoaded(filteredHistory));
    }
  }
}
