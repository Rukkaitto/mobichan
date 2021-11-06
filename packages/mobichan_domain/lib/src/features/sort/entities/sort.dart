enum Order {
  byBump,
  byReplies,
  byImages,
  byNew,
  byOld,
}

class Sort {
  final Order order;

  Sort({required this.order});

  static Sort get initial {
    return Sort(order: Order.byBump);
  }
}
