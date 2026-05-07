import 'package:hive/hive.dart';

part 'food_item_model.g.dart';

@HiveType(typeId: 2)
class FoodItem extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final double calories; // per 100g/unit
  
  @HiveField(3)
  final double protein;
  
  @HiveField(4)
  final double carbs;
  
  @HiveField(5)
  final double fats;
  
  @HiveField(6)
  bool isFavorite;

  FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.isFavorite = false,
  });
}
