// course_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

import 'package:poliglotim/domain/models/chapter.dart';
import 'package:poliglotim/domain/models/course.dart';
import 'package:poliglotim/domain/models/lesson.dart';
import 'package:poliglotim/domain/models/user.dart';
import '../../../../utils/result.dart';

typedef AuthHeaderProvider = String? Function();

class CourseClient {
  CourseClient({String? host, int? port})
    : _host = host ?? 'api.poliglotim.ru',
      _port = port ?? 80,
      _baseUrl = Uri.parse('https://${host ?? 'api.poliglotim.ru'}');

  final String _host;
  final int _port;
  final Uri _baseUrl;
  
  AuthHeaderProvider? _authHeaderProvider;

  set authHeaderProvider(AuthHeaderProvider authHeaderProvider) {
    _authHeaderProvider = authHeaderProvider;
  }

  Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    
    final authHeader = _authHeaderProvider?.call();
    if (authHeader != null) {
      headers['Authorization'] = authHeader;
    }
    
    return headers;
  }

  Uri _buildUrl(String path) {
    return _baseUrl.replace(path: path);
  }

  Future<Result<List<Course>>> getCourses() async {
    try {
      final url = _buildUrl('/courses');
      final response = await http.get(
        url,
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return Result.ok(
          json.map((element) => Course.fromJson(element)).toList(),
        );
      } else {
        return Result.error(Exception("Invalid response: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Chapter>>> getCourseChapters(String id) async {
    try {
      final url = _buildUrl('/chapters/$id');
      final response = await http.get(
        url,
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return Result.ok(
          json.map((element) => Chapter.fromJson(element)).toList(),
        );
      } else {
        return Result.error(Exception("Invalid response: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<Lesson>> getLesson(String id) async {
    try {
      final url = _buildUrl('/lesson/$id');
      final response = await http.get(
        url,
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final lesson = Lesson.fromJson(jsonDecode(response.body));
        return Result.ok(lesson);
      } else {
        return Result.error(Exception("Invalid response: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<User>> getUser() async {
    try {
      final url = _buildUrl('/user');
      final response = await http.get(
        url,
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final user = User.fromJson(jsonDecode(response.body));
        return Result.ok(user);
      } else {
        return Result.error(Exception("Invalid response: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}