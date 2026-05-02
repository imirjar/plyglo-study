// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:poliglotim/data/repositories/courses/course_repository.dart';
import 'package:poliglotim/data/services/api/course/course_client.dart';
import 'package:poliglotim/domain/models/chapter.dart';
import 'package:poliglotim/domain/models/course.dart';
import 'package:poliglotim/domain/models/lesson.dart';
import '../../../utils/result.dart';

class CourseRepositoryRemote implements CourseRepository {
  CourseRepositoryRemote({required CourseClient apiClient})
      : _apiClient = apiClient;

  final CourseClient _apiClient;

  @override
  Future<Result<List<Course>>> getCourses() => _apiClient.getCourses();

  @override
  Future<Result<List<Chapter>>> getChapters(String courseId) =>
      _apiClient.getCourseChapters(courseId);

  @override
  Future<Result<Lesson>> getLesson(String id) => _apiClient.getLesson(id);
}
