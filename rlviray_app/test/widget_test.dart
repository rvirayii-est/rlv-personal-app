import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rlviray_app/main.dart';

void main() {
  testWidgets('App should start without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts and shows the home screen
    expect(find.text('RLViray App'), findsOneWidget);
    expect(find.text('Welcome to RLViray App'), findsOneWidget);
  });
}
