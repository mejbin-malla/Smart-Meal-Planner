import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _user;
  bool _isLoggedIn = false;
  final Box<UserProfile> _userBox = Hive.box<UserProfile>(AppConstants.userBox);
  final Box<int> _settingsBox = Hive.box<int>(AppConstants.settingsBox); // Reusing settings box

  UserProfile? get user => _user;
  bool get isAuthenticated => _isLoggedIn && _user != null;
  bool get hasProfile => _userBox.isNotEmpty;

  UserProvider() {
    _loadUser();
  }

  void _loadUser() {
    if (_userBox.isNotEmpty) {
      _user = _userBox.getAt(0);
      _isLoggedIn = _settingsBox.get('isLoggedIn', defaultValue: 0) == 1;
      notifyListeners();
    }
  }

  Future<String?> register(UserProfile profile) async {
    await _userBox.clear();
    await _userBox.add(profile);
    _user = profile;
    _isLoggedIn = true;
    await _settingsBox.put('isLoggedIn', 1);
    notifyListeners();
    return null;
  }

  Future<String?> login(String name, String password) async {
    if (_userBox.isEmpty) return "No user found. Please register.";
    final user = _userBox.getAt(0);
    if (user?.name == name && user?.password == password) {
      _user = user;
      _isLoggedIn = true;
      await _settingsBox.put('isLoggedIn', 1);
      notifyListeners();
      return null;
    }
    return "Invalid name or password.";
  }

  Future<void> setupProfile(UserProfile profile) async {
    await register(profile);
  }

  Future<void> updateGoals({
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
  }) async {
    if (_user != null) {
      _user!.calorieGoal = calories;
      _user!.proteinGoal = protein;
      _user!.carbGoal = carbs;
      _user!.fatGoal = fats;
      await _user!.save();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await _settingsBox.put('isLoggedIn', 0);
    _user = null;
    notifyListeners();
  }
}
