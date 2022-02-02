import 'package:mobichan_data/mobichan_data.dart';

abstract class BoardRemoteDatasource {
  Future<List<BoardModel>> getBoards();
}

class BoardRemoteDatasourceImpl implements BoardRemoteDatasource {
  final NetworkManager networkManager;
  final String apiUrl = 'https://a.4cdn.org/boards.json';

  BoardRemoteDatasourceImpl({required this.networkManager});

  @override
  Future<List<BoardModel>> getBoards() async {
    final responseJson =
        await networkManager.makeRequest<Map<String, dynamic>>(url: apiUrl);

    final maps = responseJson['boards'] as List;
    return List.generate(
      maps.length,
      (index) => BoardModel.fromJson(maps[index]),
    );
  }
}
