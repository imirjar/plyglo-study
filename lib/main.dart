import 'package:flutter/material.dart';
import 'package:poliglotim/app/app.dart';
import 'package:poliglotim/app/app_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeAppDependencies();

  runApp(const PoliglotimApp());
}
