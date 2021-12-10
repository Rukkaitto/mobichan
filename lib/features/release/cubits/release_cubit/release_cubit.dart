import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'release_state.dart';

class ReleaseCubit extends Cubit<ReleaseState> {
  final ReleaseRepository repository;

  ReleaseCubit({required this.repository}) : super(ReleaseInitial());

  Future<void> getLatestRelease() async {
    emit(ReleaseLoading());
    try {
      final release = await repository.getLatestRelease();
      emit(ReleaseLoaded(release));
    } catch (e) {
      emit(const ReleaseError('Error while fetching latest release.'));
    }
  }
}
