part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitial extends SearchState {
  const SearchInitial();

  @override
  List<Object?> get props => [];
}

class Searching extends SearchState {
  final String input;

  const Searching(this.input);

  @override
  List<Object?> get props => [input];
}
