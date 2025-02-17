// FILE: test/widget_test.dart
//
// Basic Flutter widget test referencing the iFunLearnApp.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ifunlearn/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const iFunLearnApp());

    // Verify that our initial screen (ProfileSelectionScreen) is found.
    expect(find.text('Profiles'), findsOneWidget);

    // No actual "counter" in this project, but this ensures the app loads without error.
    // You can remove or customize this test as you build out real features.
  });
}
