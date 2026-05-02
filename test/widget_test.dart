import 'package:flutter_test/flutter_test.dart';
import 'package:poliglotim/config/dependencies.dart';
import 'package:poliglotim/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App builds with local dependencies', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: providersLocal,
        child: const MyApp(),
      ),
    );
    await tester.pump();

    expect(find.byType(MyApp), findsOneWidget);
  });
}
