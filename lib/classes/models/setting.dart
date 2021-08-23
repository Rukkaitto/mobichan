class Setting {
  final String type;
  final String label;
  final String key;
  final String value;

  Setting({
    required this.type,
    required this.label,
    required this.key,
    required this.value,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      type: json['type'],
      label: json['label'],
      key: json['key'],
      value: json['value'],
    );
  }
}
