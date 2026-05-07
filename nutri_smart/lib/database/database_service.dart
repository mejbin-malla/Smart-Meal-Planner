import 'package:hive_flutter/hive_flutter.dart';
import '../models/meal_model.dart';
import '../models/food_item_model.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(MealTypeAdapter());
    Hive.registerAdapter(MealAdapter());
    Hive.registerAdapter(FoodItemAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    
    // Open Boxes
    await Hive.openBox<UserProfile>(AppConstants.userBox);
    await Hive.openBox<Meal>(AppConstants.mealBox);
    await Hive.openBox<FoodItem>(AppConstants.foodBox);
    await Hive.openBox<int>(AppConstants.settingsBox);
    
    // Seed default food items if empty
    final foodBox = Hive.box<FoodItem>(AppConstants.foodBox);
    if (foodBox.isEmpty) {
      await _seedFoodDatabase(foodBox);
    }
  }

  static Future<void> _seedFoodDatabase(Box<FoodItem> box) async {
    final List<FoodItem> defaultFoods = [
      FoodItem(id: const Uuid().v4(), name: "Rice", calories: 130, protein: 2.7, carbs: 28, fats: 0.3),
      FoodItem(id: const Uuid().v4(), name: "Apple", calories: 52, protein: 0.3, carbs: 14, fats: 0.2),
      FoodItem(id: const Uuid().v4(), name: "Banana", calories: 89, protein: 1.1, carbs: 23, fats: 0.3),
      FoodItem(id: const Uuid().v4(), name: "Bread", calories: 265, protein: 9, carbs: 49, fats: 3.2),
      FoodItem(id: const Uuid().v4(), name: "Milk", calories: 42, protein: 3.4, carbs: 5, fats: 1),
      FoodItem(id: const Uuid().v4(), name: "Egg", calories: 155, protein: 13, carbs: 1.1, fats: 11),
      FoodItem(id: const Uuid().v4(), name: "Paneer", calories: 265, protein: 18, carbs: 1.2, fats: 20),
      FoodItem(id: const Uuid().v4(), name: "Chicken", calories: 165, protein: 31, carbs: 0, fats: 3.6),
      FoodItem(id: const Uuid().v4(), name: "Salad", calories: 15, protein: 1, carbs: 3, fats: 0.2),
      FoodItem(id: const Uuid().v4(), name: "Oats", calories: 389, protein: 16.9, carbs: 66, fats: 6.9),
    ];
    
    for (var food in defaultFoods) {
      await box.put(food.id, food);
    }
  }
}
