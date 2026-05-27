import 'package:flutter/material.dart';
import 'package:poliglotim/app/app.dart';
import 'package:poliglotim/app/app_dependencies.dart';
import 'package:poliglotim/app/config/url_strategy.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb && kReleaseMode) {
    configureUrlStrategy();
  }

  await initializeAppDependencies();

  runApp(const PoliglotimApp());
}
