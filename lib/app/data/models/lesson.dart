class Lesson {
  final String id;
  final String? chapterId;
  final String title;
  final String text;
  final int? position;
  final DateTime? updated;

  Lesson({
    required this.id,
    required this.title,
    this.chapterId,
    this.text = '',
    this.position,
    this.updated,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      chapterId: json['chapter_id'] as String? ??
          json['chapterId'] as String? ??
          json['chapterID'] as String?,
      title: (json['title'] ?? json['name']) as String,
      text: json['text'] as String? ??
          json['content'] as String? ??
          json['markdown'] as String? ??
          '',
      position: _readInt(json['position']),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );
  }

  static int? _readInt(Object? value) {
    return switch (value) {
      int() => value,
      num() => value.toInt(),
      String() => int.tryParse(value),
      _ => null,
    };
  }
}
