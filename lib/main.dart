import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/authentication/authentication.dart';
import 'package:poliglotim/app/pages/auth/view/login_screen.dart';
import 'package:poliglotim/app/pages/course/view/course_screen.dart';
import 'package:poliglotim/app/pages/core/themes/theme.dart';
import 'package:poliglotim/app/pages/courses/view/courses_screen.dart';
import 'package:poliglotim/app/pages/user/view/user_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeAuthentication();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Poliglotim',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/',
          page: () => CoursesScreen(),
        ),
        GetPage(
          name: '/user',
          page: () => UserScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/:courseSlug',
          page: () => CourseScreen(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}
