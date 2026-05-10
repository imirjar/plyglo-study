import 'package:flutter/material.dart';
import 'package:poliglotim/app/app.dart';
import 'package:poliglotim/app/app_dependencies.dart';
import 'package:poliglotim/app/config/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (const bool.fromEnvironment('USE_PATH_URL_STRATEGY')) {
    configureUrlStrategy();
  }

  await initializeAppDependencies();

  runApp(const PoliglotimApp());
}
