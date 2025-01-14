import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:thdapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end login test', () {
    testWidgets('enter login details', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Enter text into text fields
      Finder textFieldFinder = find.byType(TextField);
      await tester.enterText(textFieldFinder.first, "login details");
      await tester.enterText(textFieldFinder.last, "password details");

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Check for text in textfields
      expect(find.text('login details'), findsOneWidget);
      expect(find.text('password details'), findsOneWidget);
    });
  });
}
