class TimeZone {
  final String name;
  final int offset;

  TimeZone({required this.name, required this.offset});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'offset': offset,
    };
  }
}
