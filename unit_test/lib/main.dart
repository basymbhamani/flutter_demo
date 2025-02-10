// lib/main.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LoginManager loginManager = LoginManager(AuthServiceImpl());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(loginManager: loginManager),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final LoginManager loginManager;

  LoginScreen({required this.loginManager});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  String message = '';
  bool isLogin = true;
  bool isLoginFailed = false;

  void _login() async {
    setState(() {
      message = 'Logging in...';
      isLoginFailed = false;
    });

    bool success = await widget.loginManager.authenticate(
      usernameController.text,
      passwordController.text,
    );

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            username: usernameController.text,
            onLogout: _handleLogout,
          ),
        ),
      );
    } else {
      setState(() {
        message = 'Login Failed!';
        isLoginFailed = true;
      });
    }
  }

  void _signUp() async {
    setState(() {
      message = 'Signing up...';
      isLoginFailed = false;
    });

    bool success = await widget.loginManager.signUp(
      usernameController.text,
      passwordController.text,
    );

    if (success) {
      setState(() {
        message = 'Sign up successful! You can now log in.';
        isLogin = true;
        isLoginFailed = false;
      });

      usernameController.clear();
      passwordController.clear();
      usernameFocusNode.requestFocus();
    } else {
      setState(() {
        message = 'Sign up failed! Username may already exist.';
        isLoginFailed = true;
      });
    }
  }

  void _handleLogout() {
    setState(() {
      usernameController.clear();
      passwordController.clear();
      message = ''; // Clear the message after logout
      isLoginFailed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: Key('username_field'),
              focusNode: usernameFocusNode,
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              key: Key('password_field'),
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              key: Key('login_button'),
              onPressed: isLogin ? _login : _signUp,
              child: Text(isLogin ? 'Login' : 'Sign Up'),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: message.isNotEmpty ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Text(
                message,
                style: TextStyle(
                  color: isLoginFailed ? Colors.red : Colors.green,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                  message = '';
                  isLoginFailed = false;
                });
              },
              child: Text(isLogin ? 'Don\'t have an account? Sign Up' : 'Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String username;
  final VoidCallback onLogout;

  HomeScreen({required this.username, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $username!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onLogout();
                Navigator.pop(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
