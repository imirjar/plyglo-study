import 'package:get/get.dart';
import 'package:poliglotim/app/middlewares/auth_middleware.dart';
import 'package:poliglotim/app/ui/screens/auth/view/login_screen.dart';
import 'package:poliglotim/app/ui/screens/auth/view_models/login_viewmodel.dart';
import 'package:poliglotim/app/ui/pages/course/view_models/course_viewmodel.dart';
import 'package:poliglotim/app/ui/pages/courses/view_models/courses_viewmodel.dart';
import 'package:poliglotim/app/ui/pages/exam/view_models/exam_viewmodel.dart';
import 'package:poliglotim/app/ui/screens/home/home_screen.dart';
import 'package:poliglotim/app/ui/pages/user/view_models/user_viewmodel.dart';

class AppRoutes {
  const AppRoutes._();

  static const login = '/login';
  static const courses = '/';
  static const course = '/:courseSlug';
  static const user = '/user';
  static const exam = '/exam';

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
      page: () => const HomeScreen(section: HomeSection.courses),
      binding: BindingsBuilder(
        () => Get.lazyPut<CoursesViewModel>(() => CoursesViewModel()),
      ),
    ),
    GetPage(
      name: user,
      page: () => const HomeScreen(section: HomeSection.user),
      middlewares: [AuthMiddleware()],
      binding: BindingsBuilder(
        () => Get.lazyPut<AuthViewModel>(() => AuthViewModel()),
      ),
    ),
    GetPage(
      name: exam,
      page: () => const HomeScreen(section: HomeSection.exam),
      binding: BindingsBuilder(
        () => Get.lazyPut<ExamViewModel>(() => ExamViewModel()),
      ),
    ),
    GetPage(
      name: course,
      page: () => const HomeScreen(section: HomeSection.course),
      binding: BindingsBuilder(
        () => Get.lazyPut<CourseViewModel>(() => CourseViewModel()),
      ),
    ),
  ];
}
