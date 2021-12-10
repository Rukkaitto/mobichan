import 'package:mobichan_domain/mobichan_domain.dart';

class SortModel extends Sort {
  SortModel({required Order order}) : super(order: order);

  factory SortModel.fromEntity(Sort sort) {
    return SortModel(order: sort.order);
  }

  factory SortModel.fromString(String? string) {
    for (Order order in Order.values) {
      if (order.toString() == string) {
        return SortModel(order: order);
      }
    }
    return SortModel.fromEntity(Sort.initial);
  }

  @override
  String toString() {
    return order.toString();
  }
}
