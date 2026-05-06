// models/course.dart
class Course {
  final String id;
  final String name;
  final String description;
  final DateTime updated;
  // final FileModel? logo;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.updated,
    // this.logo,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      updated: DateTime.parse(json['updated']),
      // logo: json['logo'] != null ? FileModel.fromJson(json['logo']) : null,
    );
  }
}