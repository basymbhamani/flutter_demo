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
  final FocusNode usernameFocusNode = FocusNode(); // Add FocusNode for username
  String message = '';
  bool isLogin = true; // Track whether it's login or sign-up
  bool isLoginFailed = false; // Track login failure state

  void _login() async {
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
            usernameController: usernameController,
            passwordController: passwordController,
          ),
        ),
      );
    } else {
      setState(() {
        message = 'Login Failed!';
        isLoginFailed = true;
      });

      // Hide the message after 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          isLoginFailed = false;
        });
      });
    }
  }

  void _signUp() async {
    bool success = await widget.loginManager.signUp(
      usernameController.text,
      passwordController.text,
    );

    if (success) {
      setState(() {
        message = 'Sign up successful! You can now log in.';
        isLogin = true; // Switch back to login screen
      });

      // Clear the text fields after successful sign-up
      usernameController.clear();
      passwordController.clear();

      // Request focus on the username field
      usernameFocusNode.requestFocus();
    } else {
      setState(() {
        message = 'Sign up failed! Username may already exist.';
      });
    }
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
              focusNode: usernameFocusNode, // Set the focus node
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLogin ? _login : _signUp,
              child: Text(isLogin ? 'Login' : 'Sign Up'),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: isLoginFailed ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Text(
                message,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin; // Toggle between login and sign up
                  message = ''; // Reset message
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
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  HomeScreen({required this.username, required this.usernameController, required this.passwordController});

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
                // Clear the text fields and pop to login screen
                usernameController.clear();
                passwordController.clear();
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
