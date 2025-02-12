import 'auth_service.dart';

class LoginManager {
  final AuthService authService;

  LoginManager(this.authService);

  Future<bool> authenticate(String username, String password) async {
    //return true;
    return await authService.login(username, password);
  }

  Future<bool> signUp(String username, String password) async {
    return await authService.signUp(username, password);
  }
}
