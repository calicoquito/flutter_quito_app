// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quito_1/chatscreen.dart';
import 'package:quito_1/helperclasses/user.dart';

void main() {
  User mockUser = User();
  mockUser.username = 'someone';
  mockUser.userId = 'someoneUserId';
  mockUser.mattermostToken = 'mattermostToken';
  mockUser.ploneToken = 'ploneToken';
  mockUser.email = 'someone@example.com';

  testWidgets('Quito Chat Screen Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home:ChatScreen(user: mockUser,)));

  });
}
