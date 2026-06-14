import 'package:flutter_test/flutter_test.dart';
import 'package:poliglotim/app/core/result.dart';
import 'package:poliglotim/app/data/repositories/course_repository.dart';
import 'package:poliglotim/app/data/services/api/api_service.dart';

class _FakeApiService extends ApiService {
  _FakeApiService(this.response);

  final Object? response;

  @override
  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    return response;
  }
}

void main() {
  test('getLessons returns an empty list for an empty API list', () async {
    final repository = CourseRepository(apiService: _FakeApiService([]));

    final result = await repository.getLessons('chapter-id');

    expect(result, isA<Ok<List<dynamic>>>());
    expect((result as Ok).value, isEmpty);
  });
}
