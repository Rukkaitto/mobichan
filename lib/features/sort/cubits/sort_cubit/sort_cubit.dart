import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'sort_state.dart';

class SortCubit extends Cubit<SortState> {
  final SortRepository repository;

  SortCubit({required this.repository}) : super(SortInitial());

  Future<void> getSort() async {
    emit(SortLoading());
    try {
      final sort = await repository.getLastSort();
      emit(SortLoaded(sort));
    } catch (e) {
      emit(SortError('Could not load sort order.'));
    }
  }

  Future<void> saveSort(Sort sort) async {
    await repository.saveSort(sort);
    emit(SortLoaded(sort));
  }
}
