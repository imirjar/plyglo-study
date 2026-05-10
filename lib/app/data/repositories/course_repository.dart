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

  Future<Result<List<Chapter>>> getChapters(String courseId) async {
    try {
      final json = await _getWithFallback(
        '/chapters',
        primaryQueryParameters: {'courseID': courseId},
        fallbackQueryParameters: {'course_id': courseId},
      );
      final chaptersJson =
          json is List ? json : (json['chapters'] as List<dynamic>);

      return Result.ok(
        chaptersJson
            .map((chapterJson) =>
                Chapter.fromJson(chapterJson as Map<String, dynamic>))
            .toList(),
      );
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Lesson>>> getLessons(String chapterId) async {
    try {
      final json = await _getWithFallback(
        '/lessons',
        primaryQueryParameters: {'chapterID': chapterId},
        fallbackQueryParameters: {'chapter_id': chapterId},
      );
      final lessonsJson =
          json is List ? json : (json['lessons'] as List<dynamic>);

      return Result.ok(
        lessonsJson
            .map((lessonJson) =>
                Lesson.fromJson(lessonJson as Map<String, dynamic>))
            .toList(),
      );
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<Lesson>> getLesson(String id) async {
    try {
      final json = await _apiService.get('/lessons/$id');
      return Result.ok(Lesson.fromJson(json as Map<String, dynamic>));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<dynamic> _getWithFallback(
    String path, {
    required Map<String, String> primaryQueryParameters,
    required Map<String, String> fallbackQueryParameters,
  }) async {
    try {
      return await _apiService.get(
        path,
        queryParameters: primaryQueryParameters,
      );
    } on ApiException catch (error) {
      if (error.statusCode == 400 || error.statusCode == 404) {
        return _apiService.get(
          path,
          queryParameters: fallbackQueryParameters,
        );
      }
      rethrow;
    }
  }
}
