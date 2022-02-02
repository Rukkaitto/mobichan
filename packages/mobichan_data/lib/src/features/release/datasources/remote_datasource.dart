import 'package:mobichan_data/mobichan_data.dart';

abstract class ReleaseRemoteDatasource {
  Future<ReleaseModel> getLatestRelease();
}

class ReleaseRemoteDatasourceImpl implements ReleaseRemoteDatasource {
  final String apiUrl =
      'https://api.github.com/repos/Rukkaitto/mobichan/releases';

  final NetworkManager networkManager;

  ReleaseRemoteDatasourceImpl({
    required this.networkManager,
  });

  @override
  Future<ReleaseModel> getLatestRelease() async {
    final response = await networkManager.makeRequest<List>(url: apiUrl);
    final releases = List.generate(
      response.length,
      (index) => ReleaseModel.fromJson(response[index]),
    );
    return releases.first;
  }
}
