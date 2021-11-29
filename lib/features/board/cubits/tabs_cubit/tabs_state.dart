part of 'tabs_cubit.dart';

abstract class TabsState extends Equatable {}

class TabsInitial extends TabsState {
  @override
  List<Object> get props => [];
}

class TabsLoaded extends TabsState {
  final List<Board> boards;
  final Board current;

  TabsLoaded({required this.boards, required this.current});

  int get currentIndex => boards.indexOf(current);

  @override
  List<Object> get props => [boards, current];
}
