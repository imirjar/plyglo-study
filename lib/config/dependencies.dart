import 'package:poliglotim/data/repositories/user/user_repository_local.dart';
import 'package:poliglotim/data/repositories/user/user_repository_remote.dart';
import 'package:poliglotim/data/repositories/courses/course_repository_local.dart';
import 'package:poliglotim/data/repositories/courses/course_repository_remote.dart';
import 'package:poliglotim/data/services/api/auth/auth_client.dart';
import 'package:poliglotim/data/services/api/course/course_client.dart';
import 'package:poliglotim/data/repositories/user/user_repository.dart';
import 'package:poliglotim/data/repositories/courses/course_repository.dart';
import 'package:poliglotim/data/services/local/mocks/courses_mock.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// This dependency list uses repositories that connect to a remote server.
List<SingleChildWidget> get providersRemote {
  return [
    // Auth
    Provider(create: (context) => AuthService()),
    ChangeNotifierProvider(
      create: (context) => UserRepositoryRemote(
        authService: context.read(),
      ) as UserRepository,
    ),

    // Course
    // Provider(create: (context) => StudyApi()),
    Provider(
      create: (context) {
        final authService = context.read<AuthService>();
        return CourseClient()
          ..authHeaderProvider = authService.getAuthHeader
          ..loginHandler = () async {
            final refreshed = await authService.refreshToken();
            if (refreshed) return true;

            return authService.login();
          };
      },
    ),
    Provider(
      create: (context) => CourseRepositoryRemote(
        apiClient: context.read(),
      ) as CourseRepository,
    ),
  ];
}

List<SingleChildWidget> get providersLocal {
  return [
    // User
    Provider(create: (context) => AuthService()),
    ChangeNotifierProvider(
      create: (context) => UserRepositoryLocal() as UserRepository,
    ),

    // Course
    // Provider(create: (context) => StudyApi()),
    Provider(create: (context) => LocalCourseDataService()),
    Provider(
      create: (context) => CourseRepositoryLocal(
        localDataService: context.read(),
      ) as CourseRepository,
    ),
  ];
}
