import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/food_item_model.dart';
import '../constants/app_constants.dart';

class FoodProvider extends ChangeNotifier {
  final Box<FoodItem> _foodBox = Hive.box<FoodItem>(AppConstants.foodBox);
  List<FoodItem> _foods = [];
  String _searchQuery = "";

  List<FoodItem> get foods {
    if (_searchQuery.isEmpty) return _foods;
    return _foods.where((f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  FoodProvider() {
    _loadFoods();
  }

  void _loadFoods() {
    _foods = _foodBox.values.toList();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> toggleFavorite(FoodItem food) async {
    food.isFavorite = !food.isFavorite;
    await food.save();
    _loadFoods();
  }

  Future<void> addCustomFood(FoodItem food) async {
    await _foodBox.put(food.id, food);
    _loadFoods();
  }
}
