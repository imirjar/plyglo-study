import 'package:poliglotim/app/core/result.dart';
import 'package:poliglotim/app/data/models/chapter.dart';
import 'package:poliglotim/app/data/models/course.dart';
import 'package:poliglotim/app/data/models/lesson.dart';
import 'package:poliglotim/app/data/services/api/api_service.dart';

class CourseRepository {
  CourseRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<Result<List<Course>>> getCourses() async {
    try {
      final json = await _apiService.get('/courses') as List<dynamic>;
      return Result.ok(
        json
            .map((element) => Course.fromJson(element as Map<String, dynamic>))
            .toList(),
      );
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<Course>> getCourse(String id) async {
    try {
      final json = await _apiService.get('/courses/$id');
      return Result.ok(Course.fromJson(json as Map<String, dynamic>));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Chapter>>> getChapters(String courseId) async {
    try {
      final json = await _apiService.get(
        '/chapters',
        queryParameters: {'course_id': courseId},
      );
      final chaptersJson =
          json is List ? json : (json['chapters'] as List<dynamic>);
      final chapters = chaptersJson
          .map((chapterJson) =>
              Chapter.fromJson(chapterJson as Map<String, dynamic>))
          .toList()
        ..sort(_compareChapters);

      return Result.ok(chapters);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Lesson>>> getLessons(String chapterId) async {
    try {
      final json = await _apiService.get(
        '/lessons',
        queryParameters: {'chapter_id': chapterId},
      );
      final lessonsJson =
          json is List ? json : (json['lessons'] as List<dynamic>);
      final lessons = _mapLessons(lessonsJson);

      return Result.ok(lessons);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<Lesson>> getLesson(String id) async {
    try {
      final json = await _apiService.get('/lessons/$id');
      final lessonJson = _extractObjectJson(json, 'lesson');
      return Result.ok(Lesson.fromJson(lessonJson));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  List<Lesson> _mapLessons(List<dynamic> lessonsJson) {
    final lessons = lessonsJson
        .map(
            (lessonJson) => Lesson.fromJson(lessonJson as Map<String, dynamic>))
        .toList()
      ..sort(_compareLessons);
    return lessons;
  }

  Map<String, dynamic> _extractObjectJson(Object? json, String key) {
    if (json is Map<String, dynamic>) {
      final nested = json[key] ?? json[_capitalize(key)];
      if (nested is Map<String, dynamic>) return nested;
      return json;
    }

    throw FormatException('Expected object response for $key');
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  int _compareChapters(Chapter left, Chapter right) {
    final leftPosition = left.position;
    final rightPosition = right.position;

    if (leftPosition != null && rightPosition != null) {
      return leftPosition.compareTo(rightPosition);
    }
    if (leftPosition != null) return -1;
    if (rightPosition != null) return 1;
    return left.name.compareTo(right.name);
  }

  int _compareLessons(Lesson left, Lesson right) {
    final leftPosition = left.position;
    final rightPosition = right.position;

    if (leftPosition != null && rightPosition != null) {
      return leftPosition.compareTo(rightPosition);
    }
    if (leftPosition != null) return -1;
    if (rightPosition != null) return 1;
    return left.title.compareTo(right.title);
  }
}
