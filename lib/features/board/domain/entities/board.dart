import 'package:equatable/equatable.dart';

class Board extends Equatable {
  final String code;
  final String title;

  Board({
    required this.code,
    required this.title,
  });

  @override
  List<Object?> get props => [code, title];
}
