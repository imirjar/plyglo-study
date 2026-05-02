class Chapter {
  final String id;
  final String name;
  final String description;
  final DateTime updated;
  final String? courseId;
  final int? position;

  Chapter({
    required this.id,
    required this.name,
    required this.description,
    required this.updated,
    this.courseId,
    this.position,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      updated: DateTime.parse(json['updated'] as String),
      courseId: json['course_id'] as String?,
      position: json['position'] as int?,
    );
  }
}
