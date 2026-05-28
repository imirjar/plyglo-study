import 'package:get/get.dart';
import 'package:poliglotim/app/middlewares/auth_middleware.dart';
import 'package:poliglotim/app/pages/auth/view/login_screen.dart';
import 'package:poliglotim/app/pages/auth/view_models/login_viewmodel.dart';
import 'package:poliglotim/app/pages/course/view/course_screen.dart';
import 'package:poliglotim/app/pages/course/view_models/course_viewmodel.dart';
import 'package:poliglotim/app/pages/courses/view/courses_screen.dart';
import 'package:poliglotim/app/pages/courses/view_models/courses_viewmodel.dart';
import 'package:poliglotim/app/pages/user/view/user_screen.dart';
import 'package:poliglotim/app/pages/user/view_models/user_viewmodel.dart';

class AppRoutes {
  const AppRoutes._();

  static const login = '/login';
  static const courses = '/';
  static const user = '/user';
  static const course = '/:courseSlug';

  static final pages = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(
        () => Get.lazyPut<LoginViewModel>(() => LoginViewModel()),
      ),
    ),
    GetPage(
      name: courses,
      page: () => CoursesScreen(),
      binding: BindingsBuilder(
        () => Get.lazyPut<CoursesViewModel>(() => CoursesViewModel()),
      ),
    ),
    GetPage(
      name: user,
      page: () => UserScreen(),
      middlewares: [AuthMiddleware()],
      binding: BindingsBuilder(
        () => Get.lazyPut<AuthViewModel>(() => AuthViewModel()),
      ),
    ),
    GetPage(
      name: course,
      page: () => CourseScreen(),
      binding: BindingsBuilder(
        () => Get.lazyPut<CourseViewModel>(() => CourseViewModel()),
      ),
    ),
  ];
}
