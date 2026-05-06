import 'package:poliglotim/app/core/result.dart';
import 'package:poliglotim/app/data/models/chapter.dart';
import 'package:poliglotim/app/data/models/course.dart';
import 'package:poliglotim/app/data/models/lesson.dart';
import 'package:poliglotim/app/data/services/course_api_client.dart';

class CourseRepository {
  CourseRepository({CourseApiClient? apiClient})
      : _apiClient = apiClient ?? CourseApiClient();

  final CourseApiClient _apiClient;

  Future<Result<List<Course>>> getCourses() async {
    try {
      return Result.ok(await _apiClient.getCourses());
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Chapter>>> getChapters(String courseId) async {
    try {
      return Result.ok(await _apiClient.getChapters(courseId));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Lesson>>> getLessons(String chapterId) async {
    try {
      return Result.ok(await _apiClient.getLessons(chapterId));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<Lesson>> getLesson(String id) async {
    try {
      return Result.ok(await _apiClient.getLesson(id));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
