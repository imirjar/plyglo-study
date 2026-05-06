import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/authentication/repositories/auth_repository.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authRepository = Get.find<AuthRepository>();
    if (!authRepository.isAuthenticatedSync) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
