import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/app_routes.dart';
import 'package:poliglotim/app/pages/core/themes/theme.dart';

class PoliglotimApp extends StatelessWidget {
  const PoliglotimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Poliglotim',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.courses,
      getPages: AppRoutes.pages,
    );
  }
}
