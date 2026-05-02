import 'package:poliglotim/domain/models/chapter.dart';
import 'package:poliglotim/domain/models/lesson.dart';
import 'package:poliglotim/utils/result.dart';

import '../../../domain/models/course.dart';

abstract class CourseRepository {
  Future<Result<List<Course>>> getCourses();

  Future<Result<List<Chapter>>> getChapters(String courseID);

  Future<Result<List<Lesson>>> getLessons(String chapterID);

  Future<Result<Lesson>> getLesson(String lessonID);
}
