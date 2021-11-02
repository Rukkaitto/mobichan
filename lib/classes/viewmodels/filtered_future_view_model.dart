import 'package:stacked/stacked.dart';

abstract class FilteredFutureViewModel<T> extends FutureViewModel<List<T>> {
  late List<T> _list;
  get list => _list;

  /// Gets a list from the server.
  Future<List<T>> getDataFromServer();

  /// Filters a list by a filter string.
  List<T> filterData(List<T> list, String filter);

  @override
  void onData(List<T>? data) {
    if (data != null) {
      _list = data;
    }
    super.onData(data);
  }

  @override
  Future<List<T>> futureToRun() => getDataFromServer();

  List<T> _filterData(String filter) {
    if (filter == '') return data!;
    return filterData(data!, filter.toLowerCase().trim());
  }

  void changeFilter(String filter) {
    _list = _filterData(filter);
    notifyListeners();
  }
}
