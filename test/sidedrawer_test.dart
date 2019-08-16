// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quito_1/main.dart';
import 'package:quito_1/signinscreen.dart';

void main() {
  testWidgets('Quito Unit Tests', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    expect(find.widgetWithText(RaisedButton, 'Login'), findsOneWidget);
    expect(find.widgetWithIcon(RaisedButton, Icons.arrow_forward), findsOneWidget);

    expect(find.byType(PasswordTextField), findsNWidgets(1));

    await tester.tap(find.byType(RaisedButton));
    
    expect(find.widgetWithIcon(RaisedButton, Icons.arrow_forward), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'admin'), 'admin');
    await tester.enterText(find.widgetWithText(PasswordTextField, '12345'), '12345');
    await tester.tap(find.byType(RaisedButton));

    await tester.pump();

    expect(find.widgetWithIcon(RaisedButton, Icons.arrow_forward), findsNothing);

    // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
