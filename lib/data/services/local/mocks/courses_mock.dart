import 'package:poliglotim/domain/models/chapter.dart';
import 'package:poliglotim/domain/models/course.dart';
import 'package:poliglotim/domain/models/lesson.dart';

class LocalCourseDataService {
  List<Course> getCourses() {
    return [
      Course(
        id: '1',
        name: 'Английский язык',
        description: "asdfasdf",
        updated: DateTime.now(),
      ),
      Course(
          id: '2',
          name: 'Английский язык',
          description: "asdfasdf",
          updated: DateTime.now()),
      Course(
          id: '3',
          name: 'Шумерский язык',
          description: "asdfasdf",
          updated: DateTime.now()),
      Course(
          id: '4',
          name: 'Китайский язык>',
          description: "asdfasdf",
          updated: DateTime.now()),
    ];
  }

  List<Chapter> getCourseChapters(String id) {
    return [
      Chapter(
        id: '1',
        name: 'Глава 1',
        description: "asdfasdf",
        updated: DateTime.now(),
        courseId: id,
        position: 1,
      ),
      Chapter(
        id: '2',
        name: 'Английский язык',
        description: "asdfasdf",
        updated: DateTime.now(),
        courseId: id,
        position: 2,
      ),
      Chapter(
        id: '3',
        name: 'Шумерский язык',
        description: "asdfasdf",
        updated: DateTime.now(),
        courseId: id,
        position: 3,
      ),
      Chapter(
        id: '4',
        name: 'Китайский язык>',
        description: "asdfasdf",
        updated: DateTime.now(),
        courseId: id,
        position: 4,
      ),
    ];
  }

  List<Lesson> getChapterLessons(String chapterId) {
    return [
      Lesson(id: '$chapterId-1', chapterId: chapterId, title: "Урок 1"),
      Lesson(id: '$chapterId-2', chapterId: chapterId, title: "Урок 2"),
      Lesson(id: '$chapterId-3', chapterId: chapterId, title: "Урок 3"),
    ];
  }

  Lesson getLessonText(String lessonId) {
    return Lesson(
      id: lessonId,
      title: "Урок 1",
      text: "text",
    );
  }
}
