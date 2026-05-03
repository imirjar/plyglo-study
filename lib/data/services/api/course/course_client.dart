// course_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:poliglotim/domain/models/chapter.dart';
import 'package:poliglotim/domain/models/course.dart';
import 'package:poliglotim/domain/models/lesson.dart';
import '../../../../utils/result.dart';

typedef AuthHeaderProvider = Future<String?> Function();
typedef LoginHandler = Future<bool> Function();

class CourseClient {
  CourseClient({String? host, int? port})
      : _baseUrl = Uri(
          scheme: 'http',
          host: host ?? 'localhost',
          port: port ?? 9080,
        );

  final Uri _baseUrl;

  AuthHeaderProvider? _authHeaderProvider;
  LoginHandler? _loginHandler;

  set authHeaderProvider(AuthHeaderProvider provider) {
    _authHeaderProvider = provider;
  }

  set loginHandler(LoginHandler handler) {
    _loginHandler = handler;
  }

  Future<Map<String, String>> _getHeaders() async {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    final authHeader = await _authHeaderProvider?.call();
    if (authHeader != null) {
      headers['Authorization'] = authHeader;
    }

    return headers;
  }

  Uri _buildUrl(String path, [Map<String, String>? queryParameters]) {
    return _baseUrl.replace(
      path: path,
      queryParameters: queryParameters,
    );
  }

  List<dynamic> _readList(dynamic json, String key) {
    if (json is List<dynamic>) return json;

    if (json is Map<String, dynamic> && json[key] is List<dynamic>) {
      return json[key] as List<dynamic>;
    }

    throw const FormatException('Unexpected API response format');
  }

  Future<http.Response> _getWithAuthRetry(
    Uri url, {
    bool requiresAuth = false,
  }) async {
    if (requiresAuth && await _authHeaderProvider?.call() == null) {
      final loginSuccess = await _loginHandler?.call() ?? false;
      if (!loginSuccess) {
        return http.Response('Unauthorized', 401);
      }
    }

    var response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    if (response.statusCode != 401) {
      return response;
    }

    final loginSuccess = await _loginHandler?.call() ?? false;
    if (!loginSuccess) {
      return response;
    }

    response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    return response;
  }

  Future<Result<List<Course>>> getCourses() async {
    try {
      final url = _buildUrl('/courses');
      final response = await _getWithAuthRetry(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return Result.ok(
          json.map((element) => Course.fromJson(element)).toList(),
        );
      }

      return Result.error(
        Exception('Invalid response: ${response.statusCode}'),
      );
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Chapter>>> getChapters(String courseID) async {
    try {
      final url = _buildUrl('/chapters', {'courseID': courseID});
      var response = await _getWithAuthRetry(url, requiresAuth: true);

      if (response.statusCode == 400 || response.statusCode == 404) {
        final fallbackUrl = _buildUrl('/chapters', {'course_id': courseID});
        response = await _getWithAuthRetry(fallbackUrl, requiresAuth: true);
      }

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final chaptersJson = _readList(json, 'chapters');

        final chapters = chaptersJson.map((chapterJson) {
          return Chapter.fromJson(chapterJson as Map<String, dynamic>);
        }).toList();

        return Result.ok(chapters);
      }

      return Result.error(
        Exception('Invalid response: ${response.statusCode}'),
      );
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Lesson>>> getLessons(String lessonID) async {
    try {
      final url = _buildUrl('/lessons', {'chapterID': lessonID});
      var response = await _getWithAuthRetry(url, requiresAuth: true);

      if (response.statusCode == 400 || response.statusCode == 404) {
        final fallbackUrl = _buildUrl('/lessons', {'chapter_id': lessonID});
        response = await _getWithAuthRetry(fallbackUrl, requiresAuth: true);
      }

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final lessonsJson = _readList(json, 'lessons');

        final lessons = lessonsJson.map((lessonJson) {
          return Lesson.fromJson(lessonJson as Map<String, dynamic>);
        }).toList();

        return Result.ok(lessons);
      }

      return Result.error(
        Exception('Invalid response: ${response.statusCode}'),
      );
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<Lesson>> getLesson(String id) async {
    try {
      final url = _buildUrl('/lessons/$id');
      final response = await _getWithAuthRetry(url, requiresAuth: true);

      if (response.statusCode == 200) {
        final lesson = Lesson.fromJson(jsonDecode(response.body));
        return Result.ok(lesson);
      }

      return Result.error(
        Exception('Invalid response: ${response.statusCode}'),
      );
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
