import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poliglotim/app/data/models/chapter.dart';
import 'package:poliglotim/app/data/models/course.dart';
import 'package:poliglotim/app/data/models/lesson.dart';

class CourseApiClient {
  CourseApiClient({String? host, int? port, http.Client? httpClient})
      : _baseUrl = 'http://${host ?? 'localhost'}:${port ?? 9080}',
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  Future<List<Course>> getCourses() async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/courses'),
      headers: {'Accept': 'application/json'},
    );

    _throwIfInvalid(response);

    final json = jsonDecode(response.body) as List<dynamic>;
    return json
        .map((element) => Course.fromJson(element as Map<String, dynamic>))
        .toList();
  }

  Future<List<Chapter>> getChapters(String courseId) async {
    var response = await _httpClient.get(
      Uri.parse('$_baseUrl/chapters?courseID=$courseId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 400 || response.statusCode == 404) {
      response = await _httpClient.get(
        Uri.parse('$_baseUrl/chapters?course_id=$courseId'),
        headers: {'Accept': 'application/json'},
      );
    }

    _throwIfInvalid(response);

    final json = jsonDecode(response.body);
    final chaptersJson =
        json is List ? json : (json['chapters'] as List<dynamic>);

    return chaptersJson
        .map((chapterJson) =>
            Chapter.fromJson(chapterJson as Map<String, dynamic>))
        .toList();
  }

  Future<List<Lesson>> getLessons(String chapterId) async {
    var response = await _httpClient.get(
      Uri.parse('$_baseUrl/lessons?chapterID=$chapterId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 400 || response.statusCode == 404) {
      response = await _httpClient.get(
        Uri.parse('$_baseUrl/lessons?chapter_id=$chapterId'),
        headers: {'Accept': 'application/json'},
      );
    }

    _throwIfInvalid(response);

    final json = jsonDecode(response.body);
    final lessonsJson =
        json is List ? json : (json['lessons'] as List<dynamic>);

    return lessonsJson
        .map(
            (lessonJson) => Lesson.fromJson(lessonJson as Map<String, dynamic>))
        .toList();
  }

  Future<Lesson> getLesson(String id) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/lessons/$id'),
      headers: {'Accept': 'application/json'},
    );

    _throwIfInvalid(response);

    return Lesson.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  void _throwIfInvalid(http.Response response) {
    if (response.statusCode == 200) return;
    throw Exception('Invalid response: ${response.statusCode}');
  }
}
