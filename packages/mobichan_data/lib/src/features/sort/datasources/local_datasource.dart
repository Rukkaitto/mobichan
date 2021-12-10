import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobichan_data/mobichan_data.dart';

abstract class SortLocalDatasource {
  Future<SortModel> getLastSort();

  Future<void> saveSort(SortModel sort);
}

class SortLocalDatasourceImpl implements SortLocalDatasource {
  final String lastSortKey = 'last_sort';

  final SharedPreferences sharedPreferences;

  SortLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<SortModel> getLastSort() async {
    String? lastSortingOrderString = sharedPreferences.getString(lastSortKey);
    return SortModel.fromString(lastSortingOrderString);
  }

  @override
  Future<void> saveSort(SortModel sort) async {
    await sharedPreferences.setString(lastSortKey, sort.toString());
  }
}
