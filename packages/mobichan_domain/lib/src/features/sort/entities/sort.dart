enum Order {
  byBump,
  byReplies,
  byImages,
  byNew,
  byOld,
}

class Sort {
  final Order order;

  const Sort({required this.order});

  static Sort get initial {
    return const Sort(order: Order.byBump);
  }
}
