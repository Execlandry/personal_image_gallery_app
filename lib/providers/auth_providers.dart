import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String name;
  final String email;
  final String gender;

  User({required this.name, required this.email, required this.gender});
}

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;

  User? get currentUser => _user;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('userEmail');
    final storedPassword = prefs.getString('userPassword');

    if (email == storedEmail && password == storedPassword) {
      await prefs.setBool('isLoggedIn', true);
      _isLoggedIn = true;

      final name = prefs.getString('userName');
      final gender = prefs.getString('userGender');

      if (name != null && gender != null) {
        _user = User(name: name, email: email, gender: gender);
      } else {
        await logout();
        throw Exception('User data corrupted');
      }
      notifyListeners();
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> signup(
    String name,
    String email,
    String password,
    String gender,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', name);
      await prefs.setString('userEmail', email);
      await prefs.setString('userGender', gender);
      await prefs.setString('userPassword', password);

      _user = User(name: name, email: email, gender: gender);
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      await logout();
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (_isLoggedIn) {
      final name = prefs.getString('userName');
      final email = prefs.getString('userEmail');
      final gender = prefs.getString('userGender');

      if (name != null && email != null && gender != null) {
        _user = User(name: name, email: email, gender: gender);
      } else {
        await logout();
      }
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }
}
