import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:myapp/app_state.dart';
import 'package:myapp/main.dart';

void main() {
  testWidgets('Title smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const MyApp(),
      ),
    );

    // Verify that our title is present.
    expect(find.text('Yandex Games SDK Demo'), findsOneWidget);
  });
}
