import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/meal_model.dart';
import '../constants/app_constants.dart';
import 'package:intl/intl.dart';

class MealProvider extends ChangeNotifier {
  final Box<Meal> _mealBox = Hive.box<Meal>(AppConstants.mealBox);
  final Box<int> _waterBox = Hive.box<int>(AppConstants.settingsBox); // Reusing settings box for simplicity
  List<Meal> _meals = [];
  int _waterGlasses = 0;

  List<Meal> get meals => _meals;
  int get waterGlasses => _waterGlasses;

  MealProvider() {
    _loadMeals();
    _loadWater();
  }

  void _loadMeals() {
    _meals = _mealBox.values.toList();
    _meals.sort((a, b) => b.time.compareTo(a.time));
    notifyListeners();
  }

  void _loadWater() {
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _waterGlasses = _waterBox.get(todayKey) ?? 0;
    notifyListeners();
  }

  Future<void> addWater() async {
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _waterGlasses++;
    await _waterBox.put(todayKey, _waterGlasses);
    notifyListeners();
  }

  Future<void> removeWater() async {
    if (_waterGlasses > 0) {
      final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _waterGlasses--;
      await _waterBox.put(todayKey, _waterGlasses);
      notifyListeners();
    }
  }

  List<Meal> getMealsByDate(DateTime date) {
    return _meals.where((meal) => 
      meal.date.year == date.year && 
      meal.date.month == date.month && 
      meal.date.day == date.day
    ).toList();
  }

  String? validateMeal(Meal meal) {
    if (meal.foodName.trim().isEmpty) return "Food name cannot be empty";
    if (meal.quantity <= 0) return "Quantity must be greater than zero";
    if (meal.calories < 0) return "Calories cannot be negative";
    
    // Check for duplicate: SAME TYPE at SAME TIME on SAME DATE
    final duplicates = _meals.where((m) => 
      m.type == meal.type && 
      m.date.year == meal.date.year && 
      m.date.month == meal.date.month && 
      m.date.day == meal.date.day &&
      m.time.hour == meal.time.hour &&
      m.time.minute == meal.time.minute
    );

    if (duplicates.isNotEmpty) {
      return "A ${meal.type.name} entry already exists for this exact time.";
    }

    return null;
  }

  Future<void> addMeal(Meal meal) async {
    await _mealBox.put(meal.id, meal);
    _loadMeals();
  }

  Future<void> updateMeal(Meal meal) async {
    await meal.save();
    _loadMeals();
  }

  Future<void> deleteMeal(String id) async {
    await _mealBox.delete(id);
    _loadMeals();
  }

  double getTotalCalories(DateTime date) {
    return getMealsByDate(date).fold(0, (sum, m) => sum + m.calories);
  }

  double getTotalProtein(DateTime date) {
    return getMealsByDate(date).fold(0, (sum, m) => sum + m.protein);
  }

  double getTotalCarbs(DateTime date) {
    return getMealsByDate(date).fold(0, (sum, m) => sum + m.carbs);
  }

  double getTotalFats(DateTime date) {
    return getMealsByDate(date).fold(0, (sum, m) => sum + m.fats);
  }
}
