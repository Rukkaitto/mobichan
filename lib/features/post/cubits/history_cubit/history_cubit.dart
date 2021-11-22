import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final PostRepository repository;

  HistoryCubit({required this.repository}) : super(const HistoryInitial());

  Future<void> addToHistory(Post thread, Board board) async {
    List<Post> history = await repository.addThreadToHistory(thread, board);
    emit(HistoryLoaded(history));
  }

  Future<void> getHistory() async {
    emit(const HistoryLoading());
    List<Post> history = await repository.getHistory();
    emit(HistoryLoaded(history));
  }
}
