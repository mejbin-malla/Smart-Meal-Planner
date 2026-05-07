import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _user;
  final Box<UserProfile> _userBox = Hive.box<UserProfile>(AppConstants.userBox);

  UserProfile? get user => _user;
  bool get isAuthenticated => _user != null;

  UserProvider() {
    _loadUser();
  }

  void _loadUser() {
    if (_userBox.isNotEmpty) {
      _user = _userBox.getAt(0);
      notifyListeners();
    }
  }

  Future<void> setupProfile(UserProfile profile) async {
    await _userBox.clear();
    await _userBox.add(profile);
    _user = profile;
    notifyListeners();
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
    await _userBox.clear();
    _user = null;
    notifyListeners();
  }
}
