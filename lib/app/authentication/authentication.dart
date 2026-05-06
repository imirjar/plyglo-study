import 'package:get/get.dart';
import 'package:poliglotim/app/authentication/repositories/auth_repository.dart';

export 'package:poliglotim/app/authentication/middleware/auth_middleware.dart';

Future<void> initializeAuthentication() async {
  final authRepository = AuthRepository();
  await authRepository.initialize();

  Get.put<AuthRepository>(authRepository, permanent: true);
}
