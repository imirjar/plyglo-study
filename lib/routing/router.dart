import 'package:go_router/go_router.dart';
import 'package:poliglotim/data/repositories/auth/auth_repository.dart';
import 'package:poliglotim/ui/auth/view/login_screen.dart';
import 'package:poliglotim/ui/auth/view_models/login_viewmodel.dart';
import 'package:poliglotim/ui/course/view/course_screen.dart';
import 'package:poliglotim/ui/course/view_models/course_viewmodel.dart';
import 'package:poliglotim/ui/home/view/home_screen.dart';
import 'package:poliglotim/ui/home/view_models/home_viewmodel.dart';
import 'package:poliglotim/ui/user/view/user_screen.dart';
import 'package:poliglotim/ui/user/view_models/user_viewmodel.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  // redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    // Login page
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        final viewModel = LoginViewModel(
          authRepository: context.read(),
        );
        return LoginScreen(viewModel: viewModel);
      },
    ),
    
    // Home page
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        final viewModel = HomeViewModel(
          courseRepository:  context.read(),
        );
        return HomeScreen(viewModel: viewModel);
      },
    ),

    // Course page
    GoRoute(
      path: Routes.course,
      builder: (context, state) {
        final courseId = state.pathParameters['id']!; // Используйте pathParameters вместо params
        final viewModel = CourseViewModel(
          courseRepository: context.read(),
        );
        
        return CourseScreen(courseId: courseId, viewModel: viewModel);
      },
    ),

    //User page
    GoRoute(
      path: Routes.user,
      builder: (context, state) {
        final viewModel = AuthViewModel(
          userRepository:  context.read(),
        );
        return UserScreen(viewModel: viewModel);
      },
    ),
  ],
);
