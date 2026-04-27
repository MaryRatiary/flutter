import 'package:flutter/material.dart';

enum UserRole { director, teacher }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

class AuthProvider with ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isDirector => _user?.role == UserRole.director;

  Future<bool> login(String email, String password) async {
    // Mock login logic
    if (email == 'director@school.com' && password == 'admin123') {
      _user = AppUser(id: '1', name: 'Director Smith', email: email, role: UserRole.director);
    } else if (email == 'teacher@school.com' && password == 'teacher123') {
      _user = AppUser(id: '2', name: 'Teacher Jones', email: email, role: UserRole.teacher);
    } else {
      return false;
    }
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
