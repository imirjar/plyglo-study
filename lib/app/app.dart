import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/app_routes.dart';
import 'package:poliglotim/app/pages/core/themes/theme.dart';

class PoliglotimApp extends StatelessWidget {
  const PoliglotimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Полиглотствуем - Изучайте языки онлайн',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      getPages: AppRoutes.pages,
    );
  }
}
