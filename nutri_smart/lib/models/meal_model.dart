import 'package:hive/hive.dart';

part 'meal_model.g.dart';

@HiveType(typeId: 0)
enum MealType {
  @HiveField(0)
  breakfast,
  @HiveField(1)
  lunch,
  @HiveField(2)
  dinner,
  @HiveField(3)
  snack,
}

@HiveType(typeId: 1)
class Meal extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String foodName;
  
  @HiveField(2)
  final double quantity; // in grams or units
  
  @HiveField(3)
  final double calories;
  
  @HiveField(4)
  final double protein;
  
  @HiveField(5)
  final double carbs;
  
  @HiveField(6)
  final double fats;
  
  @HiveField(7)
  final MealType type;
  
  @HiveField(8)
  final DateTime time;
  
  @HiveField(9)
  final DateTime date;

  Meal({
    required this.id,
    required this.foodName,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.type,
    required this.time,
    required this.date,
  });
}
