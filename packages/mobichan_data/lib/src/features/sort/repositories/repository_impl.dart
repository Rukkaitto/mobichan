import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class SortRepositoryImpl implements SortRepository {
  final SortLocalDatasource localDatasource;

  SortRepositoryImpl({required this.localDatasource});

  @override
  Future<Sort> getLastSort() async {
    return localDatasource.getLastSort();
  }

  @override
  Future<void> saveSort(Sort sort) async {
    return localDatasource.saveSort(SortModel.fromEntity(sort));
  }
}
