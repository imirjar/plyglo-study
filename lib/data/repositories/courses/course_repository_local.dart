import 'package:poliglotim/data/repositories/courses/course_repository.dart';
import 'package:poliglotim/data/services/local/mocks/courses_mock.dart';
import 'package:poliglotim/domain/models/chapter.dart';
import 'package:poliglotim/domain/models/course.dart';
import 'package:poliglotim/domain/models/lesson.dart';

import '../../../utils/result.dart';

class CourseRepositoryLocal implements CourseRepository {
  CourseRepositoryLocal({required LocalCourseDataService localDataService})
      : _localDataService = localDataService;

  final LocalCourseDataService _localDataService;

  @override
  Future<Result<List<Course>>> getCourses() async {
    return Result.ok(_localDataService.getCourses());
  }

  @override
  Future<Result<List<Chapter>>> getChapters(String courseID) async {
    return Result.ok(_localDataService.getCourseChapters(courseID));
  }

  @override
  Future<Result<List<Lesson>>> getLessons(String chapterID) async {
    return Result.ok(_localDataService.getChapterLessons(chapterID));
  }

  @override
  Future<Result<Lesson>> getLesson(String lessonID) async {
    return Result.ok(_localDataService.getLessonText(lessonID));
  }
}
