import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_test/main.dart';
import 'package:unit_test/auth_service.dart';
import 'package:unit_test/login_manager.dart';


class FakeAuthService implements AuthService {
  final Map<String, String> _users = {'user': 'password123'};

  @override
  Future<bool> login(String username, String password) async {
    await Future.delayed(Duration(milliseconds: 100));
    return _users[username] == password;
  }

  @override
  Future<bool> signUp(String username, String password) async {
    if (_users.containsKey(username)) return false;
    _users[username] = password;
    return true;
  }
}

void main() {
  group('LoginScreen Widget Tests', () {
    late FakeAuthService fakeAuthService;
    late LoginManager loginManager;

    setUp(() {
      fakeAuthService = FakeAuthService();
      loginManager = LoginManager(fakeAuthService);
    });

    testWidgets('LoginScreen has username and password fields', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen(loginManager: loginManager)));

      expect(find.byKey(Key('username_field')), findsOneWidget);
      expect(find.byKey(Key('password_field')), findsOneWidget);
    });

    testWidgets('Login button is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen(loginManager: loginManager)));

      expect(find.byKey(Key('login_button')), findsOneWidget);
    });

    testWidgets('displays login screen and performs failed login', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen(loginManager: loginManager)));
      await tester.enterText(find.byKey(Key('username_field')), 'wrongUser');
      await tester.enterText(find.byKey(Key('password_field')), 'wrongPass');
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pump(Duration(milliseconds: 1000));
      await tester.pumpAndSettle();

      expect(find.text('Login Failed!'), findsOneWidget);
    });
    
    testWidgets('displays login screen and performs successful login', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen(loginManager: loginManager)));
      await tester.enterText(find.byKey(Key('username_field')), 'user');
      await tester.enterText(find.byKey(Key('password_field')), 'password123');
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Welcome, user!'), findsOneWidget);
    });


    testWidgets('displays error on sign-up with existing username', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen(loginManager: loginManager)));

      await tester.tap(find.text("Don't have an account? Sign Up"));
      await tester.enterText(find.byKey(Key('username_field')), 'user');
      await tester.enterText(find.byKey(Key('password_field')), 'password123');
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Sign up failed! Username may already exist.'), findsOneWidget);
    });

    testWidgets('successful sign-up allows subsequent login', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen(loginManager: loginManager)));

      await tester.tap(find.text("Don't have an account? Sign Up"));
      await tester.enterText(find.byKey(Key('username_field')), 'newUser');
      await tester.enterText(find.byKey(Key('password_field')), 'newPass');
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Sign up successful! You can now log in.'), findsOneWidget);

      await tester.enterText(find.byKey(Key('username_field')), 'newUser');
      await tester.enterText(find.byKey(Key('password_field')), 'newPass');
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Welcome, newUser!'), findsOneWidget);
    });
    
  });
} 
