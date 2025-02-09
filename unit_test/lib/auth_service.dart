abstract class AuthService {
  Future<bool> login(String username, String password);
  Future<bool> signUp(String username, String password);
}

class AuthServiceImpl implements AuthService {
  final List<Map<String, String>> _users = []; // Simulating a user database

  @override
  Future<bool> login(String username, String password) async {
    // Simulate a network delay
    await Future.delayed(Duration(seconds: 1));

    // Dummy authentication logic
    return _users.any((user) =>
        user['username'] == username && user['password'] == password);
  }

  @override
  Future<bool> signUp(String username, String password) async {
    // Simulate a network delay
    await Future.delayed(Duration(seconds: 1));

    // Dummy sign-up logic (checking if the username already exists)
    if (_users.any((user) => user['username'] == username)) {
      return false; // Username already exists
    }

    // Add the new user
    _users.add({'username': username, 'password': password});
    return true;
  }

  // Public method to add users (for testing purposes)
  void addUser(String username, String password) {
    _users.add({'username': username, 'password': password});
  }
}

