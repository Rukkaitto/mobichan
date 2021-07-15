import 'package:mobichan/features/board/domain/entities/board.dart';

class BoardModel extends Board {
  BoardModel({
    required String code,
    required String title,
  }) : super(
          code: code,
          title: title,
        );

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      code: json['board'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
    };
  }
}
