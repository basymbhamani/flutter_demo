import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_test/main.dart';
import 'package:unit_test/auth_service.dart';
import 'package:unit_test/login_manager.dart';


void main() {
  testWidgets('LoginScreen has username and password fields', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Verify that both text fields are present using keys
    expect(find.byKey(Key('username_field')), findsOneWidget);
    expect(find.byKey(Key('password_field')), findsOneWidget);
  });

  testWidgets('Login button is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Verify that the login button is present
    expect(find.byKey(Key('login_button')), findsOneWidget);
  });




}
