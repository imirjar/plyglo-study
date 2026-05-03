import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:poliglotim/data/services/api/auth/auth_client.dart';
import 'package:provider/provider.dart';

// import 'main_development.dart' as development;
import 'main_staging.dart' as stage;
import 'routing/router.dart';
import 'ui/core/localization/applocalization.dart';
import 'ui/core/themes/theme.dart';
// import 'ui/core/ui/scroll_behavior.dart';

/// Default main method
void main() {
  // Launch development config by default
  // development.main();
  stage.main();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthStartup(
      child: MaterialApp.router(
        localizationsDelegates: [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          AppLocalizationDelegate(),
        ],
        // scrollBehavior: AppCustomScrollBehavior(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: router(context.read()),
      ),
    );
  }
}

class AuthStartup extends StatefulWidget {
  const AuthStartup({super.key, required this.child});

  final Widget child;

  @override
  State<AuthStartup> createState() => _AuthStartupState();
}

class _AuthStartupState extends State<AuthStartup> {
  Future<bool>? _completePendingLogin;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _completePendingLogin ??=
        context.read<AuthService>().completePendingLogin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _completePendingLogin,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return widget.child;
      },
    );
  }
}
