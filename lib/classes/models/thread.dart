class Thread {
  late int no;
  late int lastModified;
  late int replies;

  Thread({required this.no, required this.lastModified, required this.replies});

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      no: json['no'],
      lastModified: json['last_modified'],
      replies: json['replies'],
    );
  }
}
