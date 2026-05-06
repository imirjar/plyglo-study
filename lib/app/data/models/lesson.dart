class Lesson {
  final String id;
  final String? chapterId;
  final String title;
  final String text;
  final DateTime? updated;

  Lesson({
    required this.id,
    required this.title,
    this.chapterId,
    this.text = '',
    this.updated,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      chapterId: json['chapter_id'] as String?,
      title: json['title'] as String,
      text: json['text'] as String? ?? '',
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );
  }
}
