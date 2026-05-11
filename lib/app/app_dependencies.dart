import 'package:get/get.dart';
import 'package:poliglotim/app/data/repositories/auth_repository.dart';
import 'package:poliglotim/app/data/repositories/course_repository.dart';
import 'package:poliglotim/app/data/services/api/api_service.dart';
import 'package:poliglotim/app/data/services/auth/auth_service.dart';

Future<void> initializeAppDependencies() async {
  final authService = AuthService();
  Get.put<AuthService>(authService, permanent: true);

  final authRepository = AuthRepository(authService: authService);
  await authRepository.initialize();
  Get.put<AuthRepository>(authRepository, permanent: true);

  Get.put<ApiService>(
    ApiService(
      authService: authService,
      onUnauthorized: authRepository.invalidateSession,
    ),
    permanent: true,
  );

  Get.lazyPut<CourseRepository>(
    () => CourseRepository(apiService: Get.find<ApiService>()),
    fenix: true,
  );
}
