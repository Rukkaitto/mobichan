import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobichan_data/mobichan_data.dart';

abstract class SortLocalDatasource {
  Future<SortModel> getLastSort();

  Future<void> saveSort(SortModel sort);
}

class SortLocalDatasourceImpl implements SortLocalDatasource {
  final String lastSortKey = 'last_sort';

  @override
  Future<SortModel> getLastSort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSortingOrderString = prefs.getString(lastSortKey);
    return SortModel.fromString(lastSortingOrderString);
  }

  @override
  Future<void> saveSort(SortModel sort) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastSortKey, sort.toString());
  }
}
