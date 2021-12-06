part of 'tabs_cubit.dart';

class TabsState extends BaseState {}

class TabsInitial extends BaseInitialState with TabsState {}

class TabsLoading extends BaseLoadingState with TabsState {}

class TabsLoaded extends BaseLoadedState<TabsLoadedArgs> with TabsState {
  final List<Board> boards;
  final Board current;

  TabsLoaded({required this.boards, required this.current})
      : super(
          TabsLoadedArgs(
            boards: boards,
            current: current,
          ),
        );

  int get currentIndex => boards.indexOf(current);

  @override
  List<Object> get props => [boards, current];
}

class TabsLoadedArgs {
  final List<Board> boards;
  final Board current;

  TabsLoadedArgs({required this.boards, required this.current});
}

class TabsError extends BaseErrorState with TabsState {
  TabsError(String message) : super(message);
}
