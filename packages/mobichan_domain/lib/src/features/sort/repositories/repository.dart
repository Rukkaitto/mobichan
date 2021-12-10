import 'package:mobichan_domain/mobichan_domain.dart';

abstract class SortRepository {
  Future<Sort> getLastSort();

  Future<void> saveSort(Sort sort);
}
